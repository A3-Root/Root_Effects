#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

// Only run on player machines
if (!hasInterface) exitWith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith {
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];

private _searchLoc = getPosATL _logic;
deleteVehicle _logic;

["Search Light Settings",[
	["EDIT",["Search Light Object","Classname of the object used as the launch generator for Missile launches."],["Land_HelipadEmpty_F"]],
	["TOOLBOX:YESNO",["Enable Alarm [READ TOOLTIP]","If true, an alarm will trigger. HIGHLY RECOMMENDED TO USE ONLY ONCE."],false]
	],{
		params ["_results", "_searchLoc"];
		_results params ["_searchObject", "_searchSound"];
		
		private _searchStart = _searchObject createVehicle _searchLoc;

		["Search Light Initiated!"] call zen_common_fnc_showMessage;

		[_searchStart, _searchSound] remoteExec [QFUNC(searchlightServer), 2];
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _searchLoc] call zen_dialog_fnc_create;


