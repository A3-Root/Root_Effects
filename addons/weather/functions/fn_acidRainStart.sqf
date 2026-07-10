#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts acid rain on the server: forces rain over the mission, broadcasts
 * the sickly tint to all clients (JIP safe) and runs the periodic exposure
 * damage to units standing in the open inside the area. Stopping the
 * instance releases the rain override.
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

// Force heavy rain while the acid rain is active.
0 setRain 1;
0 setRainbow 0;
forceWeatherChange;

if (_damage) then {
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_radius", "_damagePerTick"];

        if (isNull _anchor) exitWith {
            // Let the weather drift back to natural once the rain stops.
            30 setRain rainParams;
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
} else {
    // Without damage a light watcher still restores the weather on stop.
    [{
        params ["_args", "_handle"];
        _args params ["_anchor"];

        if (isNull _anchor) exitWith {
            30 setRain rainParams;
            _handle call CBA_fnc_removePerFrameHandler;
        };
    }, 5, [_anchor]] call CBA_fnc_addPerFrameHandler;
};

DBG(FORMAT_2("acid rain started, radius %1, damage %2",_radius,_damage));
