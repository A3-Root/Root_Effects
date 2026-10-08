#include "..\script_component.hpp"

/*
 * Author: Root
 * Adds the screen actions for one feed on this machine. Anyone near the screen can take
 * or release control. The controller gets the camera controls for the current mode:
 * zoom and vision in both, cycle view for drone feeds, and map-click retargeting for
 * satellite feeds. Conditions read the screen's live mode, so a feed switched between
 * drone and satellite through the modify dialog shows the right set at once.
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

private _isController = format ["(_target getVariable ['%1', objNull]) isEqualTo _this", QGVAR(controller)];
private _isSatellite = format ["(_target getVariable ['%1', '%2']) isEqualTo '%3'", QGVAR(mode), FEED_MODE_DRONE, FEED_MODE_SATELLITE];

private _ids = [];

_ids pushBack (_screen addAction [
    LLSTRING(ActionTakeControl),
    {
        params ["_screen", "_caller"];
        [QGVAR(setController), [_screen, _caller]] call CBA_fnc_serverEvent;
    },
    nil, 7, false, true, "",
    format ["!(%1)", _isController],
    6
]);

_ids pushBack (_screen addAction [
    LLSTRING(ActionReleaseControl),
    {
        params ["_screen"];
        [QGVAR(setController), [_screen, objNull]] call CBA_fnc_serverEvent;
    },
    nil, 1, false, true, "",
    _isController,
    6
]);

_ids pushBack (_screen addAction [
    LLSTRING(ActionZoomIn),
    {
        params ["_screen"];
        private _z = (_screen getVariable [QGVAR(zoom), DEFAULT_FOV]) - 0.08;
        _screen setVariable [QGVAR(zoom), _z max 0.05, true];
    },
    nil, 6, false, true, "", _isController, 6
]);

_ids pushBack (_screen addAction [
    LLSTRING(ActionZoomOut),
    {
        params ["_screen"];
        private _z = (_screen getVariable [QGVAR(zoom), DEFAULT_FOV]) + 0.08;
        _screen setVariable [QGVAR(zoom), _z min 1.2, true];
    },
    nil, 6, false, true, "", _isController, 6
]);

_ids pushBack (_screen addAction [
    LLSTRING(ActionVision),
    {
        params ["_screen"];
        private _v = ((_screen getVariable [QGVAR(vision), 0]) + 1) mod 3;
        _screen setVariable [QGVAR(vision), _v, true];
    },
    nil, 6, false, true, "", _isController, 6
]);

// Drone only: switch between the gunner and driver cameras.
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
    format ["(%1) && {!(%2)}", _isController, _isSatellite],
    6
]);

// Satellite only: pick a new spot on the map to look at.
_ids pushBack (_screen addAction [
    LLSTRING(ActionRetarget),
    {
        params ["_screen"];
        GVAR(retargetScreen) = _screen;
        openMap [true, false];
        hint LLSTRING(RetargetHint);
        if (!isNil QGVAR(retargetEH)) then {
            removeMissionEventHandler ["MapSingleClick", GVAR(retargetEH)];
        };
        GVAR(retargetEH) = addMissionEventHandler ["MapSingleClick", {
            params ["", "_pos"];
            removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
            GVAR(retargetEH) = nil;
            [QGVAR(setSatPos), [GVAR(retargetScreen), [_pos select 0, _pos select 1]]] call CBA_fnc_serverEvent;
            hintSilent "";
            openMap [false, false];
        }];
    },
    nil, 6, false, true, "",
    format ["(%1) && {%2}", _isController, _isSatellite],
    6
]);

_state set ["actions", _ids];
