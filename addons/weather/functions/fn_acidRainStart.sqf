#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts acid rain on the server: broadcasts the localised falling rain and
 * sickly tint to all clients (JIP safe) and runs the periodic exposure damage
 * to units standing in the open inside the area. The downpour is rendered as a
 * client side particle column confined to the area rather than a map wide
 * weather override, so only the target radius sees rain.
 *
 * Arguments:
 * 0: Position ATL of the affected area center <ARRAY>
 * 1: Area radius in meters <NUMBER>
 * 2: Tint strength 0..1 <NUMBER>
 * 3: Damage exposed units <BOOL>
 * 4: Damage per tick 0..1 <NUMBER>
 * 5: Seconds between damage ticks <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500, 0.5, true, 0.05, 5] call root_effects_weather_fnc_acidRainStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 500, [0]],
    ["_tint", 0.5, [0]],
    ["_damage", true, [false]],
    ["_damagePerTick", 0.05, [0]],
    ["_tick", 5, [0]]
];

if (!isServer) exitWith {};
if (!(["acidrain"] call EFUNC(main,isEffectEnabled))) exitWith {};

_tick = _tick max 1;
_damage = _damage && GVAR(allowDamage);

private _anchor = ["acidrain", QGVAR(acidRainLocal), [_radius, _tint], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

if (_damage) then {
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_radius", "_damagePerTick"];

        if (isNull _anchor) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        {
            private _target = _x;
            if (!(_target isKindOf "VirtualMan_F") && {isNull objectParent _target}) then {
                // Only units without a roof over their head get burned.
                private _eyePos = eyePos _target;
                private _covered = lineIntersectsSurfaces [_eyePos, _eyePos vectorAdd [0, 0, 50], _target, objNull, true, 1] isNotEqualTo [];
                if (!_covered) then {
                    [_target, _damagePerTick, "Body", "burn", _anchor] call EFUNC(main,doDamage);
                };
            };
        } forEach ((getPosATL _anchor) nearEntities [["Man"], _radius]);
    }, _tick, [_anchor, _radius, _damagePerTick]] call CBA_fnc_addPerFrameHandler;
};

DBG(FORMAT_2("acid rain started, radius %1, damage %2",_radius,_damage));
