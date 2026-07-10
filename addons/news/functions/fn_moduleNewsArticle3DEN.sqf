#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the AAN news article. Reads the module
 * attributes placed in the editor and broadcasts the article to all players
 * when the mission begins.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Module activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call root_effects_news_fnc_moduleNewsArticle3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};
if (!(["news"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _title = _logic getVariable ["ROOT_NEWS_TITLE", ""];
private _editor = _logic getVariable ["ROOT_NEWS_EDITOR", ""];
private _date = _logic getVariable ["ROOT_NEWS_DATE", "2035/2/24 11:38"];
private _timezone = _logic getVariable ["ROOT_NEWS_TIMEZONE", "CET"];
private _subhead = _logic getVariable ["ROOT_NEWS_SUBHEAD", ""];
private _mainImg = _logic getVariable ["ROOT_NEWS_IMAGE", ""];
private _mainImgDesc = _logic getVariable ["ROOT_NEWS_IMAGEDESC", ""];
private _body = _logic getVariable ["ROOT_NEWS_BODY", ""];
private _bodyLocked = _logic getVariable ["ROOT_NEWS_BODYLOCKED", ""];
private _editorImg = _logic getVariable ["ROOT_NEWS_EDITORIMG", ""];
private _editorInfo = _logic getVariable ["ROOT_NEWS_EDITORINFO", ""];
private _showNow = _logic getVariable ["ROOT_NEWS_SHOWNOW", true];
private _enableDiary = _logic getVariable ["ROOT_NEWS_DIARY", false];
private _diaryTab = _logic getVariable ["ROOT_NEWS_DIARYTAB", "AAN Reports"];

deleteVehicle _logic;

private _dateParts = (_date splitString ",-/. :") apply {parseNumber _x};
while {count _dateParts < 5} do {
    _dateParts pushBack 0;
};

private _articleData = [_title, _editor, _dateParts select [0, 5], _timezone, _subhead, _mainImg, _mainImgDesc, _body, _bodyLocked, _editorImg, _editorInfo];
private _articleId = format [QGVAR(article_mission_%1), floor CBA_missionTime];

// Everyone gets the article, including players joining later.
[QGVAR(show), [_articleId, _articleData, _showNow, false, "", _enableDiary, _diaryTab], _articleId] call CBA_fnc_globalEventJIP;
