#include "..\script_component.hpp"

/*
 * Author: Root
 * Receives an AAN article on this client: stores it for later reopening,
 * optionally shows it right away (with an optional fade-in title card) and
 * optionally files a diary entry that can reopen it at any time.
 *
 * Arguments:
 * 0: Unique article id <STRING>
 * 1: Article data for the AAN display <ARRAY>
 * 2: Show the article immediately <BOOL>
 * 3: Fade to black with a title card before showing <BOOL>
 * 4: Title card text <STRING>
 * 5: Create a diary entry <BOOL>
 * 6: Diary tab name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["myArticle", _articleData, true, false, "", true, "AAN Reports"] call root_effects_news_fnc_showArticleLocal
 */

params [["_articleId", "", [""]], ["_articleData", [], [[]]], ["_showNow", true, [false]], ["_fade", false, [false]], ["_fadeTitle", "", [""]], ["_diary", false, [false]], ["_diaryTab", "AAN Reports", [""]]];

if (!hasInterface) exitWith {};
if (_articleId isEqualTo "" || {_articleData isEqualTo []}) exitWith {};

GVAR(articles) set [_articleId, _articleData];

if (_showNow) then {
    if (_fade) then {
        [0, "BLACK", 4, 0] spawn BIS_fnc_fadeEffect;
        [[[_fadeTitle, "<t align = 'center' shadow = '1' size = '1.2' font='PuristaBold'>%1</t>"]]] spawn BIS_fnc_typeText;
        [{
            [1, "BLACK", 0.1, 0] spawn BIS_fnc_fadeEffect;
            [_this select 0] call FUNC(openArticle);
        }, [_articleId], 4.5] call CBA_fnc_waitAndExecute;
    } else {
        [_articleId] call FUNC(openArticle);
    };
};

if (_diary) then {
    player createDiaryRecord ["Diary", [
        _diaryTab,
        format ["<execute expression='[""%1""] call %2'>%3</execute>", _articleId, QFUNC(openArticle), _articleData select 0]
    ]];
};
