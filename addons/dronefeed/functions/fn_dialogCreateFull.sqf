#include "..\script_component.hpp"

/*
 * Author: Root
 * Full feed setup dialog used when the create module is dropped on open ground.
 * Spawns a fresh screen and, for a drone feed, a fresh drone, then asks the
 * server to start the feed. The curator becomes the feed's controller.
 *
 * Arguments:
 * 0: Center position ATL <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosATL _logic] call root_effects_dronefeed_fnc_dialogCreateFull
 */

params [["_pos", [0, 0, 0], [[]], 3]];

private _screenPresets = ["Land_TripodScreen_01_large_F", "Land_BriefingRoomScreen_01_F", "Land_PCSet_01_screen_F", "Land_MapBoard_F"];
private _screenNames = ["Tripod Screen", "Briefing Screen", "PC Screen", "Map Board"];

[LLSTRING(ModuleCreate), [
    ["TOOLBOX", [LLSTRING(AttrMode), LLSTRING(AttrModeTooltip)], [0, 1, 2, [LLSTRING(ModeDrone), LLSTRING(ModeSatellite)]]],
    ["COMBO", [LLSTRING(AttrScreenClass), LLSTRING(AttrScreenClassTooltip)], [_screenPresets, _screenNames, 0]],
    ["EDIT", [LLSTRING(AttrScreenCustom), LLSTRING(AttrScreenCustomTooltip)], [""]],
    ["EDIT", [LLSTRING(AttrDroneClass), LLSTRING(AttrDroneClassTooltip)], ["B_UAV_02_dynamicLoadout_F"]],
    ["SLIDER", [LLSTRING(AttrDroneAlt), LLSTRING(AttrDroneAltTooltip)], [100, 3000, 500, 0]],
    ["SLIDER", [LLSTRING(AttrTextureId), LLSTRING(AttrTextureIdTooltip)], [0, 5, 0, 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [10, 500, 100, 0, _pos, [7, 120, 32, 1]]],
    ["TOOLBOX", [LLSTRING(AttrRender), LLSTRING(AttrRenderTooltip)], [0, 1, 2, [LLSTRING(RenderAccurate), LLSTRING(RenderProxy)]]],
    ["TOOLBOX", [LLSTRING(AttrView), LLSTRING(AttrViewTooltip)], [0, 1, 3, [LLSTRING(ViewGunner), LLSTRING(ViewDriver), LLSTRING(ViewBoth)]]],
    ["SLIDER", [LLSTRING(AttrSatAlt), LLSTRING(AttrSatAltTooltip)], [200, 5000, 1000, 0]],
    ["SLIDER", [LLSTRING(AttrProxyAlt), LLSTRING(AttrProxyAltTooltip)], [200, 3000, 1200, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_mode", "_screenClass", "_screenCustom", "_droneClass", "_droneAlt", "_textureId", "_radius", "_render", "_view", "_satAlt", "_proxyAlt"];

    // Toolboxes return the selected index; map it back to the mode constant.
    _mode = [FEED_MODE_DRONE, FEED_MODE_SATELLITE] select _mode;
    _render = [RENDER_MODE_ACCURATE, RENDER_MODE_PROXY] select _render;
    _view = [VIEW_GUNNER, VIEW_DRIVER, VIEW_BOTH] select _view;

    if (_screenCustom isNotEqualTo "") then {_screenClass = _screenCustom};

    private _config = [_pos, _mode, "", _screenClass, "", _droneClass, _droneAlt, _textureId, _radius, _render, _view, _satAlt, _proxyAlt, netId player];
    [QGVAR(requestCreate), [_config]] call CBA_fnc_serverEvent;
    [LLSTRING(FeedCreated)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(createDialog)] call zen_dialog_fnc_create;
