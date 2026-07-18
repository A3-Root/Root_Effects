#include "..\script_component.hpp"

/*
 * Author: Root
 * Feed setup dialog used when the create module is dropped on a screen object:
 * the screen is fixed, so it only asks which drone to show, either an existing
 * UAV from the list or a freshly spawned one.
 *
 * Arguments:
 * 0: Center position ATL <ARRAY>
 * 1: Target screen <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosATL _logic, _screen] call root_effects_dronefeed_fnc_dialogScreenSource
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_screen", objNull, [objNull]]];

if (isNull _screen) exitWith {};

// Build the drone picker: a "spawn new" entry first, then every existing UAV.
private _droneValues = [""];
private _droneLabels = [LLSTRING(DroneSpawnNew)];
{
    _x params ["_drone", "_label"];
    _droneValues pushBack (netId _drone);
    _droneLabels pushBack _label;
} forEach (call FUNC(getDroneList));

[LLSTRING(ModuleCreate), [
    ["COMBO", [LLSTRING(AttrDroneSource), LLSTRING(AttrDroneSourceTooltip)], [_droneValues, _droneLabels, 0]],
    ["EDIT", [LLSTRING(AttrDroneClass), LLSTRING(AttrDroneClassTooltip)], ["B_UAV_02_dynamicLoadout_F"]],
    ["SLIDER", [LLSTRING(AttrDroneAlt), LLSTRING(AttrDroneAltTooltip)], [100, 3000, 500, 0]],
    ["SLIDER", [LLSTRING(AttrTextureId), LLSTRING(AttrTextureIdTooltip)], [0, 5, 0, 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [10, 500, 100, 0, _pos, [7, 120, 32, 1]]],
    ["TOOLBOX", [LLSTRING(AttrRender), LLSTRING(AttrRenderTooltip)], [[RENDER_MODE_ACCURATE, RENDER_MODE_PROXY], [LLSTRING(RenderAccurate), LLSTRING(RenderProxy)], 0]],
    ["TOOLBOX", [LLSTRING(AttrView), LLSTRING(AttrViewTooltip)], [[VIEW_GUNNER, VIEW_DRIVER, VIEW_BOTH], [LLSTRING(ViewGunner), LLSTRING(ViewDriver), LLSTRING(ViewBoth)], 0]],
    ["SLIDER", [LLSTRING(AttrProxyAlt), LLSTRING(AttrProxyAltTooltip)], [200, 3000, 1200, 0]]
], {
    params ["_results", "_data"];
    _data params ["_pos", "_screenNetId"];
    _results params ["_droneSel", "_droneClass", "_droneAlt", "_textureId", "_radius", "_render", "_view", "_proxyAlt"];

    private _config = [_pos, FEED_MODE_DRONE, _screenNetId, "", _droneSel, _droneClass, _droneAlt, _textureId, _radius, _render, _view, 1000, _proxyAlt, netId player];
    [QGVAR(requestCreate), [_config]] call CBA_fnc_serverEvent;
    [LLSTRING(FeedCreated)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_pos, netId _screen], QGVAR(screenSourceDialog)] call zen_dialog_fnc_create;
