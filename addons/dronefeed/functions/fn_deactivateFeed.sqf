#include "..\script_component.hpp"

/*
 * Author: Root
 * Takes a feed's picture down on this machine when the player leaves its range:
 * destroys the camera, stops the tracking loops, removes the actions, clears the
 * screen texture and restores the saved video settings once no feed is left in
 * range.
 *
 * Arguments:
 * 0: Feed id <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["df_1_2"] call root_effects_dronefeed_fnc_deactivateFeed
 */

params [["_feedId", "", [""]]];

private _state = GVAR(activeFeeds) getOrDefault [_feedId, createHashMap];
if (count _state == 0) exitWith {};
if (!(_state get "active")) exitWith {};

private _cam = _state getOrDefault ["camera", objNull];
if (!isNull _cam) then {
    _cam cameraEffect ["TERMINATE", "BACK"];
    camDestroy _cam;
};
_state set ["camera", objNull];

private _trackPFH = _state getOrDefault ["trackPFH", -1];
if (_trackPFH >= 0) then {
    _trackPFH call CBA_fnc_removePerFrameHandler;
    _state set ["trackPFH", -1];
};

private _cyclePFH = _state getOrDefault ["cyclePFH", -1];
if (_cyclePFH >= 0) then {
    _cyclePFH call CBA_fnc_removePerFrameHandler;
    _state set ["cyclePFH", -1];
};

[_feedId] call FUNC(removeActions);

private _screen = _state get "screen";
if (!isNull _screen) then {
    _screen setObjectTexture [_state get "textureId", ""];
};

_state set ["active", false];

// Restore the video settings only once the player has left the last feed.
GVAR(proximityCount) = (GVAR(proximityCount) - 1) max 0;
if (GVAR(proximityCount) == 0 && {!isNil {GVAR(savedViewDistance)}}) then {
    GVAR(savedViewDistance) params ["_pip", "_vd", "_ovd", "_shadow"];
    setPiPViewDistance _pip;
    setViewDistance _vd;
    setObjectViewDistance _ovd;
    setShadowDistance _shadow;
    GVAR(savedViewDistance) = nil;
};
