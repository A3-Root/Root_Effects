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
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 30, true] call root_effects_meteor_fnc_meteorsStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_interval", 30, [0]],
    ["_lethal", true, [false]]
];

if (!isServer) exitWith {};
if (!(["meteors"] call EFUNC(main,isEffectEnabled))) exitWith {};

_interval = _interval max 5;
_lethal = _lethal && GVAR(allowLethality);

private _anchor = ["meteors", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_lethal"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    [_anchor, _lethal] call FUNC(spawnMeteor);
}, _interval, [_anchor, _lethal]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("meteor spawner started, interval %1, lethal %2",_interval,_lethal));
