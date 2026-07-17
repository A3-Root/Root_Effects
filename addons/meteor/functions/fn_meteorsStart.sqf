#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts the meteor spawner on the server: creates the anchor and schedules
 * one falling meteor near a random player at every interval. Meteors are
 * transient, so no JIP replay is needed; late joiners simply see the next
 * one.
 *
 * Arguments:
 * 0: Position ATL of the module, used as fallback target <ARRAY>
 * 1: Seconds between meteors <NUMBER>
 * 2: Impacts damage nearby units <BOOL>
 * 3: Target mode, 0 random players / 1 module area / 2 specific owners <NUMBER>
 * 4: Area radius in meters, target mode 1 only <NUMBER>
 * 5: Owners to target [sides, groups, players, tab], target mode 2 only <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 30, true, 0, 300, []] call root_effects_meteor_fnc_meteorsStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_interval", 30, [0]],
    ["_lethal", true, [false]],
    ["_targetMode", 0, [0]],
    ["_targetRadius", 300, [0]],
    ["_owners", [], [[]]]
];

if (!isServer) exitWith {};
if (!(["meteors"] call EFUNC(main,isEffectEnabled))) exitWith {};

_interval = _interval max 5;
_lethal = _lethal && GVAR(allowLethality);

private _anchor = ["meteors", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// The spawner reads the targeting choice back off the anchor for every meteor,
// so a running instance keeps aiming the way it was set up.
_anchor setVariable [QGVAR(targetMode), _targetMode];
_anchor setVariable [QGVAR(targetRadius), _targetRadius];
_anchor setVariable [QGVAR(targetOwners), _owners];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_lethal"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    [_anchor, _lethal] call FUNC(spawnMeteor);
}, _interval, [_anchor, _lethal]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("meteor spawner started, interval %1, lethal %2",_interval,_lethal));
