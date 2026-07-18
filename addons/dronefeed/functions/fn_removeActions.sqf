#include "..\script_component.hpp"

/*
 * Author: Root
 * Removes the scroll wheel actions previously added to a feed screen.
 *
 * Arguments:
 * 0: Feed id <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["df_1_2"] call root_effects_dronefeed_fnc_removeActions
 */

params [["_feedId", "", [""]]];

private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
if (count _state == 0) exitWith {};

private _screen = _state get "screen";
private _ids = _state getOrDefault ["actions", []];
if (!isNull _screen) then {
    {
        _screen removeAction _x;
    } forEach _ids;
};

_state set ["actions", []];
