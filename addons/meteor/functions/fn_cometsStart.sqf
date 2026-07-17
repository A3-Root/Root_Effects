#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts the comet spawner on the server: creates the anchor and schedules
 * one comet streaking across the sky near a random player at every interval.
 *
 * Arguments:
 * 0: Position ATL of the module, used as fallback target <ARRAY>
 * 1: Seconds between comets <NUMBER>
 * 2: Target mode, 0 random players / 1 module area / 2 specific owners <NUMBER>
 * 3: Area radius in meters, target mode 1 only <NUMBER>
 * 4: Owners to target [sides, groups, players, tab], target mode 2 only <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 30, 0, 300, []] call root_effects_meteor_fnc_cometsStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_interval", 30, [0]],
    ["_targetMode", 0, [0]],
    ["_targetRadius", 300, [0]],
    ["_owners", [], [[]]]
];

if (!isServer) exitWith {};
if (!(["comets"] call EFUNC(main,isEffectEnabled))) exitWith {};

_interval = _interval max 5;

private _anchor = ["comets", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// The spawner reads the targeting choice back off the anchor for every comet,
// so a running instance keeps aiming the way it was set up.
_anchor setVariable [QGVAR(targetMode), _targetMode];
_anchor setVariable [QGVAR(targetRadius), _targetRadius];
_anchor setVariable [QGVAR(targetOwners), _owners];

[{
    params ["_args", "_handle"];
    _args params ["_anchor"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    [_anchor] call FUNC(spawnComet);
}, _interval, [_anchor]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_1("comet spawner started, interval %1",_interval));
