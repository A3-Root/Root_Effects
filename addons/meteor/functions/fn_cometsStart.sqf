#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts the comet spawner on the server: creates the anchor and schedules
 * one comet streaking across the sky near a random player at every interval.
 *
 * Arguments:
 * 0: Position ATL of the module, used as fallback target <ARRAY>
 * 1: Seconds between comets <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 30] call root_effects_meteor_fnc_cometsStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_interval", 30, [0]]
];

if (!isServer) exitWith {};
if (!(["comets"] call EFUNC(main,isEffectEnabled))) exitWith {};

_interval = _interval max 5;

private _anchor = ["comets", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    [_anchor] call FUNC(spawnComet);
}, _interval, [_anchor]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_1("comet spawner started, interval %1",_interval));
