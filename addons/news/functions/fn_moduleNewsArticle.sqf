#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the AAN news article. Opens the article editor
 * dialog on the curator's machine, builds the article data once and sends it
 * to the machines of all selected players, where it is shown and optionally
 * archived in their diary.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_news_fnc_moduleNewsArticle
 */

params [["_logic", objNull, [objNull]]];

deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["news"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleNews), [
    ["EDIT", [LLSTRING(AttrTitle), LLSTRING(AttrTitleTooltip)], ["ARMA 3 - The Frontier of Armaverse"]],
    ["EDIT", [LLSTRING(AttrEditor), LLSTRING(AttrEditorTooltip)], ["Root"]],
    ["EDIT", [LLSTRING(AttrDate), LLSTRING(AttrDateTooltip)], ["2035/2/24 11:38"]],
    ["EDIT", [LLSTRING(AttrTimezone), LLSTRING(AttrTimezoneTooltip)], ["CET"]],
    ["EDIT", [LLSTRING(AttrSubhead), LLSTRING(AttrSubheadTooltip)], [""]],
    ["EDIT", [LLSTRING(AttrImage), LLSTRING(AttrImageTooltip)], [""]],
    ["EDIT", [LLSTRING(AttrImageDesc), LLSTRING(AttrImageDescTooltip)], [""]],
    ["EDIT:MULTI", [LLSTRING(AttrBody), LLSTRING(AttrBodyTooltip)], ["", {}, 7]],
    ["EDIT:MULTI", [LLSTRING(AttrBodyLocked), LLSTRING(AttrBodyLockedTooltip)], ["", {}, 7]],
    ["EDIT", [LLSTRING(AttrEditorImg), LLSTRING(AttrEditorImgTooltip)], [""]],
    ["EDIT:MULTI", [LLSTRING(AttrEditorInfo), LLSTRING(AttrEditorInfoTooltip)], ["", {}, 3]],
    ["CHECKBOX", [LLSTRING(AttrFade), LLSTRING(AttrFadeTooltip)], false],
    ["EDIT", [LLSTRING(AttrFadeTitle), LLSTRING(AttrFadeTitleTooltip)], [""]],
    ["CHECKBOX", [LLSTRING(AttrDiary), LLSTRING(AttrDiaryTooltip)], false],
    ["EDIT", [LLSTRING(AttrDiaryTab), LLSTRING(AttrDiaryTabTooltip)], ["AAN Reports"]],
    ["CHECKBOX", [LLSTRING(AttrShowNow), LLSTRING(AttrShowNowTooltip)], true],
    ["OWNERS", [LLSTRING(AttrTargets), LLSTRING(AttrTargetsTooltip)], [[], [], [], 0], true]
], {
    params ["_results"];
    _results params ["_title", "_editor", "_date", "_timezone", "_subhead", "_mainImg", "_mainImgDesc", "_body", "_bodyLocked", "_editorImg", "_editorInfo", "_enableFade", "_fadeTitle", "_enableDiary", "_diaryTab", "_showNow", "_selected"];
    _selected params ["_sides", "_groups", "_players"];

    if (_sides isEqualTo [] && {_groups isEqualTo []} && {_players isEqualTo []}) exitWith {
        [LLSTRING(NoSelection)] call zen_common_fnc_showMessage;
    };

    private _targets = (call CBA_fnc_players) select {
        !(_x isKindOf "VirtualMan_F")
        && {(side _x) in _sides || {(group _x) in _groups} || {_x in _players}}
    };
    if (_targets isEqualTo []) exitWith {
        [LLSTRING(NoSelection)] call zen_common_fnc_showMessage;
    };

    if (_diaryTab isEqualTo "") then {
        _diaryTab = "AAN Reports";
    };

    private _dateParts = (_date splitString ",-/. :") apply {parseNumber _x};
    while {count _dateParts < 5} do {
        _dateParts pushBack 0;
    };

    private _articleData = [_title, _editor, _dateParts select [0, 5], _timezone, _subhead, _mainImg, _mainImgDesc, _body, _bodyLocked, _editorImg, _editorInfo];
    private _articleId = format [QGVAR(article_%1_%2), clientOwner, floor CBA_missionTime];

    [QGVAR(show), [_articleId, _articleData, _showNow, _enableFade, _fadeTitle, _enableDiary, _diaryTab], _targets] call CBA_fnc_targetEvent;
    [LLSTRING(ArticleSent)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [], QGVAR(dialog)] call zen_dialog_fnc_create;
