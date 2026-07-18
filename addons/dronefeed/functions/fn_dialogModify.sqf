#include "..\script_component.hpp"

/*
 * Author: Root
 * Modify dialog built from the server's feed snapshot. Every field defaults to
 * "no change" and carries an explicit value on confirm, so a setting is only
 * touched when the curator actually picks a new value for it.
 *
 * Arguments:
 * 0: Feed snapshot [[feedId, screenNetId, mode, grid], ...] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[["df_1_2", "3:4", "DRONE", "045012"]]] call root_effects_dronefeed_fnc_dialogModify
 */

params [["_data", [], [[]]]];

if (_data isEqualTo []) exitWith {
    [LLSTRING(NoFeeds)] call zen_common_fnc_showMessage;
};

private _feedIds = [];
private _feedLabels = [];
{
    _x params ["_feedId", "", "_mode", "_grid"];
    _feedIds pushBack _feedId;
    _feedLabels pushBack format ["%1 [%2]", _mode, _grid];
} forEach _data;

[LLSTRING(ModuleModify), [
    ["COMBO", [LLSTRING(AttrFeed), LLSTRING(AttrFeedTooltip)], [_feedIds, _feedLabels, 0]],
    ["TOOLBOX", [LLSTRING(AttrView), LLSTRING(AttrViewTooltip)], [["", VIEW_GUNNER, VIEW_DRIVER, VIEW_BOTH], [LLSTRING(NoChange), LLSTRING(ViewGunner), LLSTRING(ViewDriver), LLSTRING(ViewBoth)], 0]],
    ["TOOLBOX", [LLSTRING(AttrVision), LLSTRING(AttrVisionTooltip)], [[-1, 0, 1, 2], [LLSTRING(NoChange), LLSTRING(VisionNormal), LLSTRING(VisionNV), LLSTRING(VisionThermal)], 0]],
    ["TOOLBOX", [LLSTRING(AttrRender), LLSTRING(AttrRenderTooltip)], [["", RENDER_MODE_ACCURATE, RENDER_MODE_PROXY], [LLSTRING(NoChange), LLSTRING(RenderAccurate), LLSTRING(RenderProxy)], 0]],
    ["SLIDER", [LLSTRING(AttrRadiusChange), LLSTRING(AttrRadiusChangeTooltip)], [0, 500, 0, 0]]
], {
    params ["_results"];
    _results params ["_feedId", "_view", "_vision", "_render", "_radius"];

    [QGVAR(requestModify), [[_feedId, _view, _vision, _render, _radius, "", ""]]] call CBA_fnc_serverEvent;
    [LLSTRING(FeedModified)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [], QGVAR(modifyDialog)] call zen_dialog_fnc_create;
