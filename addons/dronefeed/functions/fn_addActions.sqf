#include "..\script_component.hpp"

/*
 * Author: Root
 * Adds the scroll wheel actions to a feed screen while the player is near it:
 * zoom, vision mode and, for the feed's controller, camera view. Each action
 * writes the feed's shared state so the change shows on every viewer's screen.
 *
 * Arguments:
 * 0: Feed id <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["df_1_2"] call root_effects_dronefeed_fnc_addActions
 */

params [["_feedId", "", [""]]];

private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
if (count _state == 0) exitWith {};

private _screen = _state get "screen";
if (isNull _screen) exitWith {};

private _ids = [];

_ids pushBack (_screen addAction [
    LLSTRING(ActionZoomIn),
    {
        params ["_screen"];
        private _z = (_screen getVariable [QGVAR(zoom), DEFAULT_FOV]) - 0.08;
        _screen setVariable [QGVAR(zoom), _z max 0.05, true];
    },
    nil, 6, false, true, "", "true", 6
]);

_ids pushBack (_screen addAction [
    LLSTRING(ActionZoomOut),
    {
        params ["_screen"];
        private _z = (_screen getVariable [QGVAR(zoom), DEFAULT_FOV]) + 0.08;
        _screen setVariable [QGVAR(zoom), _z min 1.2, true];
    },
    nil, 6, false, true, "", "true", 6
]);

_ids pushBack (_screen addAction [
    LLSTRING(ActionVision),
    {
        params ["_screen"];
        private _v = ((_screen getVariable [QGVAR(vision), 0]) + 1) mod 3;
        _screen setVariable [QGVAR(vision), _v, true];
    },
    nil, 6, false, true, "", "true", 6
]);

// Only the designated controller can change the camera view.
_ids pushBack (_screen addAction [
    LLSTRING(ActionCycleView),
    {
        params ["_screen"];
        private _cur = _screen getVariable [QGVAR(view), VIEW_GUNNER];
        private _next = switch (_cur) do {
            case VIEW_GUNNER: {VIEW_DRIVER};
            case VIEW_DRIVER: {VIEW_BOTH};
            default {VIEW_GUNNER};
        };
        _screen setVariable [QGVAR(view), _next, true];
    },
    nil, 6, false, true, "",
    format ["(_target getVariable ['%1', objNull]) isEqualTo _this", QGVAR(controller)],
    6
]);

_state set ["actions", _ids];
