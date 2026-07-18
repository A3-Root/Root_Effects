#include "..\script_component.hpp"

/*
 * Author: Root
 * Fully removes a feed from this machine once its anchor is gone: deactivates
 * the picture if it is up, stops the proximity watcher and drops the feed from
 * the local registry.
 *
 * Arguments:
 * 0: Feed id <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["df_1_2"] call root_effects_dronefeed_fnc_teardownFeedLocal
 */

params [["_feedId", "", [""]]];

private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
if (count _state == 0) exitWith {};

if (_state get "active") then {
    [_feedId] call FUNC(deactivateFeed);
};

private _proxPFH = _state getOrDefault ["proximityPFH", -1];
if (_proxPFH >= 0) then {
    _proxPFH call CBA_fnc_removePerFrameHandler;
};

GVAR(activeFeeds) deleteAt _feedId;
