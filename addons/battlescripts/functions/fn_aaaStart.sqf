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
 * 8: Fraction of the radius the bursts spread over, 0..1 <NUMBER>
 * 9: Bursts fired per cycle <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500, 150, true, 0.05, 0.2, 1, false, 1, 1] call root_effects_battlescripts_fnc_aaaStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 500, [0]],
    ["_altitude", 150, [0]],
    ["_lethal", true, [false]],
    ["_damageAir", 0.05, [0]],
    ["_damageInf", 0.2, [0]],
    ["_burstDelay", 1, [0]],
    ["_smokeOnly", false, [false]],
    ["_spread", 1, [0]],
    ["_fireRate", 1, [0]]
];

if (!isServer) exitWith {};
if (!(["aaa"] call EFUNC(main,isEffectEnabled))) exitWith {};

_burstDelay = _burstDelay max 0.5;
_lethal = _lethal && GVAR(allowDamage);
_spread = 0 max _spread min 1;
_fireRate = round (1 max _fireRate min 8);

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["aaa", QGVAR(aaaLocal), [_radius, _smokeOnly], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_altitude", "_lethal", "_damageAir", "_damageInf", "_smokeOnly", "_spread", "_fireRate", "_burstDelay"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Bursts of a cycle are spaced across the cycle so a high fire rate reads
    // as a rolling barrage rather than one simultaneous clap.
    private _burstSpacing = _burstDelay / _fireRate;
    for "_i" from 0 to (_fireRate - 1) do {
        [{
            params ["_anchor", "_radius", "_altitude", "_smokeOnly", "_spread"];
            if (isNull _anchor) exitWith {};

            // Random detonation point inside the barrage cylinder; a tighter
            // spread concentrates the flak around the module position.
            private _burstPos = _anchor getPos [random (_radius * _spread), random 360];
            _burstPos set [2, _altitude + (selectRandom [1, -1]) * random 50];

            [QGVAR(aaaBurst), [_anchor, _burstPos, _smokeOnly]] call CBA_fnc_globalEvent;
        }, [_anchor, _radius, _altitude, _smokeOnly, _spread], _i * _burstSpacing] call CBA_fnc_waitAndExecute;
    };

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
                        // Flak shrapnel peppers the aircraft hitpoints unevenly; two
                        // passes of independently randomised damage per burst make the
                        // wear accumulate in frequent, scattered increments.
                        [_target, _damageAir, true] call EFUNC(main,doHitPointDamage);
                        [_target, _damageAir, true] call EFUNC(main,doHitPointDamage);
                    };
                };
            };
        } forEach _nearby;
    };
}, _burstDelay, [_anchor, _radius, _altitude, _lethal, _damageAir, _damageInf, _smokeOnly, _spread, _fireRate, _burstDelay]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("aaa barrage started, radius %1, altitude %2",_radius,_altitude));
