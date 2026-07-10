#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts the UFO encounter scheduler on the server: creates the anchor and
 * triggers a random sighting (fast crossing object or hovering light charge)
 * near a random player at every interval.
 *
 * Arguments:
 * 0: Position ATL of the module, used as fallback target <ARRAY>
 * 1: Seconds between sightings <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 30] call root_effects_ufo_fnc_encounterStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_interval", 30, [0]]
];

if (!isServer) exitWith {};
if (!(["ufoencounter"] call EFUNC(main,isEffectEnabled))) exitWith {};

_interval = _interval max 10;

private _anchor = ["ufoencounter", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _target = [getPosATL _anchor] call FUNC(pickTarget);
    private _appearPos = _target getPos [200 + random 1800, selectRandom [random 60, random -60]];
    _appearPos set [2, 200 + random 1800];

    if (selectRandom [true, false]) then {
        [_appearPos] call FUNC(crossFlyby);
    } else {
        [QGVAR(jumpLocal), [_appearPos]] call CBA_fnc_globalEvent;
    };
}, _interval, [_anchor]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_1("ufo encounter started, interval %1",_interval));
