#include "..\script_component.hpp"

/*
 * Author: Root
 * Opens a previously received AAN article on this client, either right after
 * delivery or later from its diary entry.
 *
 * Arguments:
 * 0: Unique article id <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["myArticle"] call root_effects_news_fnc_openArticle
 */

params [["_articleId", "", [""]]];

if (!hasInterface) exitWith {};

private _articleData = GVAR(articles) getOrDefault [_articleId, []];
if (_articleData isEqualTo []) exitWith {};

_articleData params ["_title", "_editor", "_dateParts", "_timezone", "_subhead", "_mainImg", "_mainImgDesc", "_body", "_bodyLocked", "_editorImg", "_editorInfo"];

private _lockMessage = format ["%1<br/>---------------------------------------------------------------<br/>%2", localize LSTRING(LockLimit), localize LSTRING(LockSubscribe)];

disableSerialization;
[[
    ["title", _title],
    ["meta", [_editor, _dateParts, _timezone]],
    ["textbold", _subhead],
    ["image", [_mainImg, _mainImgDesc]],
    ["text", _body],
    ["textlocked", [_bodyLocked, _lockMessage]],
    ["author", [_editorImg, _editorInfo]]
], findDisplay 46, true] spawn BIS_fnc_showAANArticle;
