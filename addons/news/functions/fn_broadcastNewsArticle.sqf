#include "..\script_component.hpp"

// CREATED BY ROOT
// Only run on server
if (!isServer) exitWith {};
// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith
{
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params  ["_title", "_editor", "_newDate", "_timezone", "_subhead", "_mainImg", "_mainImgDesc", "_body", "_bodyLocked", "_lockMsg", "_editorImg", "_editorInfo", "_sides", "_groups", "_players", "_diaryTitle"];
private ["_year", "_month", "_day", "_hour", "_minute"];
_year = parseNumber (_newDate select 0);
_day = parseNumber (_newDate select 1);
_month = parseNumber (_newDate select 2);
_hour = parseNumber (_newDate select 3);
_minute = parseNumber (_newDate select 4);
private _authorData = [_editorImg, _editorInfo];

{
	_x createDiaryRecord
	[
		"diary",
		[
			_diaryTitle,
			format ["<execute expression='
			[] spawn 
			{
				disableSerialization;
				[
					[
						[""title"", ""%1""], 
						[""meta"",[""%2"",""[%3"",""%4"",""%5"",""%6"",""%7]"",""%8""]],
						[""textbold"",""%9""],
						[""image"",[""%10"",""%11""]],
						[""text"",""%12""],
						[""textlocked"",[""%13"",""%14""]],
						[""author"",%15]
					],findDisplay 46,true
				] call BIS_fnc_ShowAANArticle;
			}
			'>""AAN Article""</execute>", _title, _editor, _year, _day, _month, _hour, _minute, _timezone, _subhead, _mainImg, _mainImgDesc, _body, _bodyLocked, _lockMsg, _authorData]
		]
	];
} forEach ((call CBA_fnc_players) select {(side _x) in _sides || {(group _x) in _groups} || {_x in _players}});
