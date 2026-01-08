// CREATED BY ROOT
// Only run on server
if (!isServer) exitwith {};
// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitwith
{
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params  ["_title", "_editor", "_new_date", "_timezone", "_subhead", "_main_img", "_main_img_desc", "_body", "_body_locked", "_lock_msg", "_editor_img", "_editor_info", "_sides", "_groups", "_players", "_diary_title"];
private ["_year", "_month", "_day", "_hour", "_minute"];
_year = parseNumber (_new_date select 0);
_day = parseNumber (_new_date select 1);
_month = parseNumber (_new_date select 2);
_hour = parseNumber (_new_date select 3);
_minute = parseNumber (_new_date select 4);

{
	_x createDiaryRecord
	[
		"diary",
		[
			_diary_title,
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
						[""author"",[""%15"",""%15""]]
					],findDisplay 46,true
				] call BIS_fnc_showAANArticle;
			}
			'>""AAN Article""</execute>", _title, _editor, _year, _day, _month, _hour, _minute, _timezone, _subhead, _main_img, _main_img_desc, _body, _body_locked, _lock_msg, _editor_img, _editor_info]
		]
	];
} forEach ((call CBA_fnc_players) select {(side _x) in _sides || {(group _x) in _groups} || {_x in _players}});
