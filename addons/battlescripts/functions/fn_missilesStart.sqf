#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts an ambient missile launcher on the server: creates the anchor and
 * schedules a recurring launch event. The rockets themselves are pure client
 * side visuals.
 *
 * Arguments:
 * 0: Position ATL of the launch site <ARRAY>
 * 1: Minimum player distance before rockets are shown <NUMBER>
 * 2: Delay between launches in seconds <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 25, 10] call root_effects_battlescripts_fnc_missilesStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_safeDistance", 25, [0]],
    ["_launchDelay", 10, [0]]
];

if (!isServer) exitWith {};
if (!(["missiles"] call EFUNC(main,isEffectEnabled))) exitWith {};

_launchDelay = _launchDelay max 1;

private _anchor = ["missiles", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_safeDistance", "_launchDelay"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    [QGVAR(missileLaunch), [_anchor, _safeDistance, _launchDelay]] call CBA_fnc_globalEvent;
}, _launchDelay, [_anchor, _safeDistance, _launchDelay]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("missile launcher started, safe distance %1, delay %2",_safeDistance,_launchDelay));
