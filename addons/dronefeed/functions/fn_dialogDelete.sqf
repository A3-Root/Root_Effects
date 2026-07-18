#include "..\script_component.hpp"

/*
 * Author: Root
 * Delete dialog built from the server's feed snapshot: pick a feed to stop and
 * choose whether the screen and drone spawned for it are removed too.
 *
 * Arguments:
 * 0: Feed snapshot [[feedId, screenNetId, mode, grid], ...] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[["df_1_2", "3:4", "DRONE", "045012"]]] call root_effects_dronefeed_fnc_dialogDelete
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

[LLSTRING(ModuleDelete), [
    ["COMBO", [LLSTRING(AttrFeed), LLSTRING(AttrFeedTooltip)], [_feedIds, _feedLabels, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrDeleteSpawned), LLSTRING(AttrDeleteSpawnedTooltip)], true]
], {
    params ["_results"];
    _results params ["_feedId", "_deleteSpawned"];

    [QGVAR(requestDelete), [[_feedId, _deleteSpawned]]] call CBA_fnc_serverEvent;
    [LLSTRING(FeedDeleted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [], QGVAR(deleteDialog)] call zen_dialog_fnc_create;
