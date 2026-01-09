#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


/*
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

private _fireflyPos = getPosATL _logic;
deleteVehicle _logic;

["Ambient Firefly Setting", [
	["EDIT", ["Firefly Object", "Classname of the object used as a source for the SFX."], ["Land_HelipadEmpty_F"]], 
	["SLIDER", ["Fireflies Altitude", "Altitude in meters where you want the Fireflies."], [1, 100, 1, 0]],
	["SLIDER", ["Fireflies Distance", "Distance in meters players have to be to view/trigger the Fireflies."], [10, 500, 10, 0]]
	], {
		params ["_results", "_fireflyPos"];
		_results params ["_fireflyClass", "_fireflyAltitude", "_activationDistance"];
		
		private _fireflySource = _fireflyClass createVehicle _fireflyPos;

		["Fireflies Active!"] call zen_common_fnc_showMessage;

		[_fireflySource, _fireflyAltitude, _activationDistance] remoteExec [QFUNC(fireflyServer), 2];
	}, {
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _fireflyPos] call zen_dialog_fnc_create;

