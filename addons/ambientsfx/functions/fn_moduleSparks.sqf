#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

/*
[object_name] execvm "AL_ambientSFX\sparky.sqf";
object_name - string, the name of the object you use as a source for the SFX
*/

// Only run on player machines
if (!hasInterface) exitWith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith
{
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];

private _sparksPos = getPosATL _logic;
deleteVehicle _logic;

["Ambient Sparks Setting", [
	["EDIT", ["Sparks Object", "Classname of the object used as a source for the SFX."], ["Land_HelipadEmpty_F"]], 
	["SLIDER", ["Sparks Altitude", "Altitude in meters where you want the Sparks Rupture. (Minimum Altitude is 1m)"], [0, 100, 0, 0]],
	["SLIDER",["Sparks Delay", "Seconds between each spark."],[1,100,10,0]]
	], {
		params ["_results", "_sparksPos"];
		_results params ["_sparksClass", "_sparkAltitude", "_sparkDelay"];
		
		private _sparkSource = _sparksClass createVehicle _sparksPos;

		["Sparks Active!"] call zen_common_fnc_showMessage;

		[_sparkSource, _sparkAltitude, _sparkDelay] remoteExec [QFUNC(sparksServer), 2];
	}, {
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _sparksPos] call zen_dialog_fnc_create;

