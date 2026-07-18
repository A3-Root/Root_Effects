#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side setup for one feed. Records the feed on this machine and starts a
 * proximity watcher that renders the feed only while the player is close to the
 * screen and tears everything down once the anchor is gone. JIP safe: the
 * anchor is prepended by the shared startEffect broadcast.
 *
 * Arguments:
 * 0: Anchor <OBJECT>
 * 1: Feed id <STRING>
 * 2: Screen netId <STRING>
 * 3: Drone netId, "" for satellite <STRING>
 * 4: Feed mode <STRING>
 * 5: Texture index <NUMBER>
 * 6: RTT resolution <NUMBER>
 * 7: Proximity radius <NUMBER>
 * 8: Render mode <STRING>
 * 9: Camera view <STRING>
 * 10: Satellite altitude <NUMBER>
 * 11: Proxy altitude <NUMBER>
 * 12: Auto cycle interval <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, "df_1_2", "3:4", "", "SATELLITE", 0, 1024, 100, "ACCURATE", "GUNNER", 1000, 1200, 10] call root_effects_dronefeed_fnc_setupFeedLocal
 */

if (!hasInterface) exitWith {};

params [
    ["_anchor", objNull, [objNull]],
    ["_feedId", "", [""]],
    ["_screenNetId", "", [""]],
    ["_droneNetId", "", [""]],
    ["_mode", FEED_MODE_DRONE, [""]],
    ["_textureId", 0, [0]],
    ["_rttRes", 1024, [0]],
    ["_radius", 100, [0]],
    ["_renderMode", RENDER_MODE_ACCURATE, [""]],
    ["_view", VIEW_GUNNER, [""]],
    ["_satAlt", 1000, [0]],
    ["_proxyAlt", 1200, [0]],
    ["_cycleInterval", 10, [0]]
];

if (isNull _anchor) exitWith {};
if (_feedId in GVAR(activeFeeds)) exitWith {};

private _screen = objectFromNetId _screenNetId;
if (isNull _screen) exitWith {};

private _state = createHashMapFromArray [
    ["anchor", _anchor],
    ["feedId", _feedId],
    ["screen", _screen],
    ["mode", _mode],
    ["textureId", _textureId],
    ["rttName", format ["rootdf_%1", _feedId]],
    ["rttRes", _rttRes],
    ["radius", _radius],
    ["satAlt", _satAlt],
    ["proxyAlt", _proxyAlt],
    ["cycleInterval", _cycleInterval],
    ["camera", objNull],
    ["active", false],
    ["trackPFH", -1],
    ["cyclePFH", -1],
    ["actions", []],
    ["currentView", _view],
    ["clobberTimer", 0]
];

GVAR(activeFeeds) set [_feedId, _state];

// Proximity watcher: brings the feed up in range, takes it down out of range and
// self-destructs once the anchor (and with it the whole feed) is deleted.
private _pfh = [{
    params ["_args", "_handle"];
    _args params ["_feedId"];

    private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
    private _anchor = _state getOrDefault ["anchor", objNull];

    if (isNull _anchor) exitWith {
        [_feedId] call FUNC(teardownFeedLocal);
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _screen = _state get "screen";
    if (isNull _screen) exitWith {
        [_feedId] call FUNC(teardownFeedLocal);
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Radius can be changed live through the modify dialog.
    private _radius = _screen getVariable [QGVAR(radius), _state get "radius"];
    _state set ["radius", _radius];

    private _near = (player distance _screen) <= _radius;
    private _active = _state get "active";

    if (_near && !_active) then {
        [_feedId] call FUNC(activateFeed);
    };
    if (!_near && _active) then {
        [_feedId] call FUNC(deactivateFeed);
    };
}, 0.5, [_feedId]] call CBA_fnc_addPerFrameHandler;

_state set ["proximityPFH", _pfh];
