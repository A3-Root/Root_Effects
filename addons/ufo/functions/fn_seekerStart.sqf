#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts the UFO seeker scheduler on the server: creates the anchor and
 * triggers a wandering seeker light near a random player at every interval.
 *
 * Arguments:
 * 0: Position ATL of the module, used as fallback target <ARRAY>
 * 1: Seconds between seeker visits <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 30] call root_effects_ufo_fnc_seekerStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_interval", 30, [0]]
];

if (!isServer) exitWith {};
if (!(["ufoseeker"] call EFUNC(main,isEffectEnabled))) exitWith {};

_interval = _interval max 10;

private _anchor = ["ufoseeker", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _target = [getPosATL _anchor] call FUNC(pickTarget);
    private _visitPos = _target getPos [100 + random 500, selectRandom [random 60, random -60]];

    [QGVAR(seekerLocal), [_visitPos]] call CBA_fnc_globalEvent;
}, _interval, [_anchor]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_1("ufo seeker started, interval %1",_interval));
