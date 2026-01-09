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

private _missileLoc = getPosATL _logic;
deleteVehicle _logic;

["Missile Launcher Settings",[
	["EDIT",["Missile Launcher Object","Classname of the object used as the launch generator for Missile launches."],["Land_HelipadEmpty_F"]],
	["SLIDER:RADIUS",["Minimum Safe Distance","Radius is meters for players to be AWAY to lauch Missiles."],[1,1000,25,0,_missileLoc,[7,120,32,1]]],
	["SLIDER",["Launch Delay","Seconds between each Launch."],[1,100,10,0]]
	],{
		params ["_results", "_missileLoc"];
		_results params ["_missileObject", "_minimumDistance", "_launchDelay"];
		
		private _missileStart = _missileObject createVehicle _missileLoc;

		["Missile Launcher Initiated!"] call zen_common_fnc_showMessage;

		[_missileStart, _minimumDistance, _launchDelay] remoteExec [QFUNC(missileLauncherServer), 2];
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _missileLoc] call zen_dialog_fnc_create;

