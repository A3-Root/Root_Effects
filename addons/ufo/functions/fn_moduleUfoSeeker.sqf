#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 
/*
=============>>> UFO encounters <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

[freq] execvm "\Root_Effects\Root_UFO\AL_ufo\fn_ufoSeekerServer.sqf";

freq - frequency in seconds of how often the specific phenomena takes place
*/


// Only run on player machines
if (!hasInterface) exitWith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith {
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];
deleteVehicle _logic;

["UFO Seeker Settings",[
	["SLIDER",["UFO Seeker Frequency","Frequency in seconds of how often the phenomena takes place."],[10,600,30,0]]
	],{
		params ["_results"];
		_results params ["_seekerfreq"];
		
		["UFO Seeker Configured and Created!"] call zen_common_fnc_showMessage;

		[_seekerfreq] remoteExec [QFUNC(ufoSeekerServer), 2];
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}] call zen_dialog_fnc_create;

