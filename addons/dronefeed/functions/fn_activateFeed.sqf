#include "..\script_component.hpp"

/*
 * Author: Root
 * Brings a feed's picture up on this machine: creates the render to texture
 * camera, paints the screen, adds the scroll actions and starts the per frame
 * tracking loop. The loop aims the camera (turret tracking for drone gunner
 * views, top down for satellite), keeps zoom and vision in sync with the feed's
 * shared state and re-asserts the render binding whenever an interface such as
 * Zeus, the map or vehicle optics steals it.
 *
 * Arguments:
 * 0: Feed id <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["df_1_2"] call root_effects_dronefeed_fnc_activateFeed
 */

params [["_feedId", "", [""]]];

private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
if (count _state == 0) exitWith {};
if (_state get "active") exitWith {};

private _screen = _state get "screen";
if (isNull _screen) exitWith {};

private _rtt = _state get "rttName";
private _res = _state get "rttRes";
private _texId = _state get "textureId";

// Save the video settings on the first feed entered and raise them so a high
// altitude drone or satellite still renders terrain in the picture.
GVAR(proximityCount) = GVAR(proximityCount) + 1;
if (GVAR(proximityCount) == 1) then {
    GVAR(savedViewDistance) = [getPiPViewDistance, viewDistance, getObjectViewDistance, getShadowDistance];
    private _mode = _state get "mode";
    private _target = if (_mode isEqualTo FEED_MODE_SATELLITE) then {_state get "satAlt"} else {_state get "proxyAlt"};
    private _wanted = ((_target + 1000) max 3000) min 10000;
    setViewDistance (viewDistance max _wanted);
    setPiPViewDistance _wanted;
    setObjectViewDistance [_wanted, 0];
    setShadowDistance 0;
};

private _cam = "camera" camCreate (getPosATL player);
_cam setPosATL (getPosATL player);
_cam cameraEffect ["INTERNAL", "BACK", _rtt];
_cam camSetFov (_screen getVariable [QGVAR(zoom), DEFAULT_FOV]);
_cam camCommit 0;
_rtt setPiPEffect [_screen getVariable [QGVAR(vision), 0]];

_screen setObjectTexture [_texId, format ["#(argb,%1,%1,1)r2t(%2,1.0)", _res, _rtt]];

_state set ["camera", _cam];
_state set ["active", true];
_state set ["clobberSig", []];
_state set ["clobberTimer", 0];
_state set ["appliedZoom", -1];
_state set ["appliedVision", -1];
_state set ["cycleView", VIEW_GUNNER];

[_feedId] call FUNC(addActions);

// Per frame tracking and interface-clobber recovery.
private _trackPFH = [{
    params ["_args", "_handle"];
    _args params ["_feedId"];

    private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
    private _cam = _state getOrDefault ["camera", objNull];
    if (isNull _cam) exitWith {_handle call CBA_fnc_removePerFrameHandler};

    private _screen = _state get "screen";
    if (isNull _screen) exitWith {};

    private _rtt = _state get "rttName";
    private _vision = _screen getVariable [QGVAR(vision), 0];
    private _zoom = _screen getVariable [QGVAR(zoom), DEFAULT_FOV];

    // Re-assert the render binding on any interface change, and unconditionally
    // once a second, so opening Zeus, the arsenal, the map or optics cannot
    // leave the screen frozen for more than a moment.
    private _sig = [cameraView, visibleMap, !isNull (findDisplay 312), !isNull (findDisplay 49), isGamePaused];
    private _timer = (_state getOrDefault ["clobberTimer", 0]) + diag_deltaTime;
    if (_sig isNotEqualTo (_state getOrDefault ["clobberSig", []]) || {_timer >= 1}) then {
        _cam cameraEffect ["INTERNAL", "BACK", _rtt];
        _cam camCommit 0;
        _rtt setPiPEffect [_vision];
        _state set ["clobberSig", _sig];
        if (_timer >= 1) then {_timer = 0};
    };
    _state set ["clobberTimer", _timer];

    if (_zoom != (_state getOrDefault ["appliedZoom", -1])) then {
        _cam camSetFov _zoom;
        _state set ["appliedZoom", _zoom];
    };
    if (_vision != (_state getOrDefault ["appliedVision", -1])) then {
        _rtt setPiPEffect [_vision];
        _state set ["appliedVision", _vision];
    };

    if ((_state get "mode") isEqualTo FEED_MODE_SATELLITE) exitWith {
        private _satPos = _screen getVariable [QGVAR(satPos), [0, 0]];
        private _alt = _screen getVariable [QGVAR(satAlt), _state get "satAlt"];
        _cam camSetPos [_satPos select 0, _satPos select 1, _alt];
        _cam camSetTarget [_satPos select 0, _satPos select 1, 0];
        _cam camCommit 0;
    };

    // Drone feed.
    private _drone = objectFromNetId (_screen getVariable [QGVAR(droneNetId), ""]);
    if (isNull _drone || {!alive _drone}) exitWith {};

    private _view = _screen getVariable [QGVAR(view), VIEW_GUNNER];
    private _actualView = if (_view isEqualTo VIEW_BOTH) then {_state getOrDefault ["cycleView", VIEW_GUNNER]} else {_view};

    ([_drone, _actualView] call FUNC(getTurretAim)) params ["_camPos", "_dir"];

    private _renderMode = _screen getVariable [QGVAR(renderMode), RENDER_MODE_ACCURATE];
    if (_renderMode isEqualTo RENDER_MODE_PROXY && {_actualView isEqualTo VIEW_GUNNER}) then {
        // Top down proxy: look straight down at the ground point the turret is
        // aimed at, from the configured proxy altitude.
        private _hits = lineIntersectsSurfaces [_camPos, _camPos vectorAdd (_dir vectorMultiply 12000), _drone, objNull, true, 1, "GEOM", "NONE"];
        private _ground = if (_hits isEqualTo []) then {
            _camPos vectorAdd (_dir vectorMultiply 3000)
        } else {
            (_hits select 0) select 0
        };
        private _proxyAlt = _state get "proxyAlt";
        _cam camSetPos [_ground select 0, _ground select 1, (_ground select 2) + _proxyAlt];
        _cam camSetTarget _ground;
        _cam camCommit 0;
    } else {
        _cam camSetPos _camPos;
        _cam camSetTarget (_camPos vectorAdd (_dir vectorMultiply 1000));
        _cam camCommit 0;
    };
}, 0, [_feedId]] call CBA_fnc_addPerFrameHandler;

_state set ["trackPFH", _trackPFH];

// Auto-cycle gunner and driver for the "both" view so every viewer sees the
// same picture at the same time.
if ((_screen getVariable [QGVAR(view), VIEW_GUNNER]) isEqualTo VIEW_BOTH) then {
    private _cyclePFH = [{
        params ["_args", "_handle"];
        _args params ["_feedId"];
        private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
        if (count _state == 0 || {!(_state get "active")}) exitWith {_handle call CBA_fnc_removePerFrameHandler};
        private _next = [VIEW_DRIVER, VIEW_GUNNER] select ((_state getOrDefault ["cycleView", VIEW_GUNNER]) isEqualTo VIEW_DRIVER);
        _state set ["cycleView", _next];
    }, _state get "cycleInterval", [_feedId]] call CBA_fnc_addPerFrameHandler;
    _state set ["cyclePFH", _cyclePFH];
};
