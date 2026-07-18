#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Spawns one falling meteor on the server near a random player: creates the
 * global meteor body, broadcasts the client side trail visuals, tracks the
 * fall and on impact broadcasts the impact visuals and applies the area
 * damage once, server side.
 *
 * Arguments:
 * 0: Spawner anchor <OBJECT>
 * 1: Impact damages nearby units <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, true] call root_effects_meteor_fnc_spawnMeteor
 */

params [["_anchor", objNull, [objNull]], ["_lethal", true, [false]]];

if (!isServer) exitWith {};

private _target = [
    getPosATL _anchor,
    _anchor getVariable [QGVAR(targetMode), 0],
    _anchor getVariable [QGVAR(targetRadius), 300],
    _anchor getVariable [QGVAR(targetOwners), []]
] call FUNC(pickTarget);
// Spawn high above the chosen impact point with a modest lateral offset so the
// meteor streaks in on a slant, then aim its velocity straight at that point so
// it actually converges on the target rather than drifting off ballistically.
private _targetGround = [_target select 0, _target select 1, 0];
private _startPos = _targetGround vectorAdd [
    (selectRandom [1, -1]) * (150 + random 200),
    (selectRandom [1, -1]) * (150 + random 200),
    1000
];

private _meteor = createVehicle ["Land_Battery_F", _startPos, [], 0, "CAN_COLLIDE"];
_meteor setPosATL _startPos;

private _velocity = (_targetGround vectorDiff _startPos) vectorMultiply (180 / (_targetGround vectorDistance _startPos));
_velocity params ["_velocityX", "_velocityY"];

[QGVAR(meteorLocal), [_meteor]] call CBA_fnc_globalEvent;

_meteor setVelocity _velocity;

[{
    params ["_args", "_handle"];
    _args params ["_meteor", "_velocityX", "_velocityY", "_lethal", "_anchor"];

    if (isNull _meteor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    if ((getPos _meteor select 2) >= 20) exitWith {};

    _handle call CBA_fnc_removePerFrameHandler;

    private _impactPos = getPos _meteor;
    deleteVehicle _meteor;

    [QGVAR(meteorImpact), [_impactPos, _velocityX, _velocityY, true, netId _anchor]] call CBA_fnc_globalEvent;

    if (_lethal) then {
        {
            if (!(_x isKindOf "VirtualMan_F")) then {
                if (_x isKindOf "Man" || {_x isKindOf "LandVehicle"} || {_x isKindOf "Air"}) then {
                    _x setVelocity [random 3, random 3, random 30];
                };
                [_x, 1, "Body", "explosive", _anchor] call EFUNC(main,doDamage);
            };
        } forEach (_impactPos nearEntities [["Man", "LandVehicle", "Air"], 100]);
    };

    // Optional destruction of the impact site itself: level nearby buildings and
    // flatten vegetation so the strike leaves a scar on the world, not just on
    // the units standing in it. Gated by the global damage kill switch.
    if ((_anchor getVariable [QGVAR(structureDamage), false]) && EGVAR(main,damageAllowed)) then {
        private _structureRadius = 25;
        {
            _x setDamage 1;
        } forEach (nearestTerrainObjects [_impactPos, ["HOUSE", "BUILDING", "CHURCH", "TREE", "SMALL TREE", "BUSH", "FENCE", "WALL"], _structureRadius, false, true]);
        {
            if (!(_x isKindOf "Man") && {!(_x isKindOf "AllVehicles")}) then {
                _x setDamage 1;
            };
        } forEach (nearestObjects [_impactPos, ["Building", "Wall", "Fence"], _structureRadius]);
    };
}, 0.1, [_meteor, _velocityX, _velocityY, _lethal, _anchor]] call CBA_fnc_addPerFrameHandler;
