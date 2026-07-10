#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts an anti air barrage on the server: creates the anchor, broadcasts
 * the persistent smoke layer to all clients (JIP safe) and schedules the
 * recurring flak bursts. Damage is applied once, server side, per burst.
 *
 * Arguments:
 * 0: Position ATL of the barrage center <ARRAY>
 * 1: Barrage radius in meters <NUMBER>
 * 2: Barrage altitude above terrain in meters <NUMBER>
 * 3: Damage entities inside the barrage zone <BOOL>
 * 4: Damage per burst added to aircraft hitpoints, 0..1 <NUMBER>
 * 5: Damage per burst added to infantry, 0..1 <NUMBER>
 * 6: Delay between bursts in seconds <NUMBER>
 * 7: Render smoke only, no flash <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500, 150, true, 0.05, 0.2, 1, false] call root_effects_battlescripts_fnc_aaaStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 500, [0]],
    ["_altitude", 150, [0]],
    ["_lethal", true, [false]],
    ["_damageAir", 0.05, [0]],
    ["_damageInf", 0.2, [0]],
    ["_burstDelay", 1, [0]],
    ["_smokeOnly", false, [false]]
];

if (!isServer) exitWith {};
if (!(["aaa"] call EFUNC(main,isEffectEnabled))) exitWith {};

_burstDelay = _burstDelay max 0.5;
_lethal = _lethal && GVAR(allowDamage);

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["aaa", QGVAR(aaaLocal), [_radius, _smokeOnly], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_altitude", "_lethal", "_damageAir", "_damageInf", "_smokeOnly"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Random detonation point inside the barrage cylinder.
    private _burstPos = _anchor getPos [random _radius, random 360];
    _burstPos set [2, _altitude + (selectRandom [1, -1]) * random 50];

    [QGVAR(aaaBurst), [_anchor, _burstPos, _smokeOnly]] call CBA_fnc_globalEvent;

    if (_lethal) then {
        private _zone = getPosATL _anchor;
        private _nearby = (_zone nearEntities [["CAManBase", "Air"], _radius + 5]) inAreaArray [_zone, _radius * 2, _radius * 2, 0, false, _altitude / 2];

        {
            private _target = _x;
            if (!(_target isKindOf "VirtualMan_F")) then {
                if (_target isKindOf "CAManBase" && {!((vehicle _target) isKindOf "Air")}) then {
                    private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3, 0.8, 0.65, 0.5, 0.8, 0.65];
                    private _damageType = selectRandom ["backblast", "explosive", "grenade", "burning"];
                    [_target, _damageInf, _bodyPart, _damageType, _anchor] call EFUNC(main,doDamage);
                } else {
                    if (_target isKindOf "Air") then {
                        // Flak shrapnel peppers random aircraft hitpoints.
                        private _hitpoints = (getAllHitPointsDamage _target) param [0, []];
                        {
                            _target setHitPointDamage [_x, ((_target getHitPointDamage _x) + random _damageAir) min 1];
                        } forEach _hitpoints;
                    };
                };
            };
        } forEach _nearby;
    };
}, _burstDelay, [_anchor, _radius, _altitude, _lethal, _damageAir, _damageInf, _smokeOnly]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("aaa barrage started, radius %1, altitude %2",_radius,_altitude));
