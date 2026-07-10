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

private _target = [getPosATL _anchor] call FUNC(pickTarget);
private _startPos = [
    (_target select 0) + random (selectRandom [1000, -1000]),
    (_target select 1) + random (selectRandom [1000, -1000]),
    800
];

private _meteor = createVehicle ["Land_Battery_F", _startPos, [], 0, "CAN_COLLIDE"];
_meteor setPosATL _startPos;

private _velocityX = ((_startPos select 0) + random (selectRandom [1000, -1000])) / 200;
private _velocityY = ((_startPos select 1) + random (selectRandom [1, -1])) / 200;

[QGVAR(meteorLocal), [_meteor]] call CBA_fnc_globalEvent;

_meteor setVelocity [_velocityX, _velocityY, -100];

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

    [QGVAR(meteorImpact), [_impactPos, _velocityX, _velocityY, true]] call CBA_fnc_globalEvent;

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
}, 0.1, [_meteor, _velocityX, _velocityY, _lethal, _anchor]] call CBA_fnc_addPerFrameHandler;
