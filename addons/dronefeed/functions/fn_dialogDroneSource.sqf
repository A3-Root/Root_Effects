#include "..\script_component.hpp"

/*
 * Author: Root
 * Feed setup dialog used when the create module is dropped on a UAV: the drone
 * is fixed, so it only asks for the screen to spawn and the feed options.
 *
 * Arguments:
 * 0: Center position ATL <ARRAY>
 * 1: Source drone <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosATL _logic, _drone] call root_effects_dronefeed_fnc_dialogDroneSource
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_drone", objNull, [objNull]]];

if (isNull _drone) exitWith {};

private _screenPresets = ["Land_TripodScreen_01_large_F", "Land_BriefingRoomScreen_01_F", "Land_PCSet_01_screen_F", "Land_MapBoard_F"];
private _screenNames = ["Tripod Screen", "Briefing Screen", "PC Screen", "Map Board"];

[LLSTRING(ModuleCreate), [
    ["COMBO", [LLSTRING(AttrScreenClass), LLSTRING(AttrScreenClassTooltip)], [_screenPresets, _screenNames, 0]],
    ["EDIT", [LLSTRING(AttrScreenCustom), LLSTRING(AttrScreenCustomTooltip)], [""]],
    ["SLIDER", [LLSTRING(AttrTextureId), LLSTRING(AttrTextureIdTooltip)], [0, 5, 0, 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [10, 500, 100, 0, _pos, [7, 120, 32, 1]]],
    ["TOOLBOX", [LLSTRING(AttrRender), LLSTRING(AttrRenderTooltip)], [[RENDER_MODE_ACCURATE, RENDER_MODE_PROXY], [LLSTRING(RenderAccurate), LLSTRING(RenderProxy)], 0]],
    ["TOOLBOX", [LLSTRING(AttrView), LLSTRING(AttrViewTooltip)], [[VIEW_GUNNER, VIEW_DRIVER, VIEW_BOTH], [LLSTRING(ViewGunner), LLSTRING(ViewDriver), LLSTRING(ViewBoth)], 0]],
    ["SLIDER", [LLSTRING(AttrProxyAlt), LLSTRING(AttrProxyAltTooltip)], [200, 3000, 1200, 0]]
], {
    params ["_results", "_data"];
    _data params ["_pos", "_droneNetId"];
    _results params ["_screenClass", "_screenCustom", "_textureId", "_radius", "_render", "_view", "_proxyAlt"];

    if (_screenCustom isNotEqualTo "") then {_screenClass = _screenCustom};

    private _config = [_pos, FEED_MODE_DRONE, "", _screenClass, _droneNetId, "", 500, _textureId, _radius, _render, _view, 1000, _proxyAlt, netId player];
    [QGVAR(requestCreate), [_config]] call CBA_fnc_serverEvent;
    [LLSTRING(FeedCreated)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_pos, netId _drone], QGVAR(droneSourceDialog)] call zen_dialog_fnc_create;
