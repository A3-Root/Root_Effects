#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


/*
[object_name] execvm "AL_ambientSFX\rupture.sqf";
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

private _rupturePos = getPosATL _logic;
deleteVehicle _logic;

["Ambient Rupture Setting", [
	["EDIT", ["Rupture Object", "Classname of the object used as a source for the SFX."], ["Land_HelipadEmpty_F"]], 
	["SLIDER", ["Rupture Altitude", "Altitude in meters where you want the Spacetime Rupture."], [1, 4000, 500, 0]],
	["SLIDER", ["Rupture Spawn Speed", "Time taken between each 'light' for the rupture to spawn in."], [0.1, 20, 0.1, 1]]
	], {
		params ["_results", "_rupturePos"];
		_results params ["_ruptureClass", "_ruptureAltitude", "_spawnInterval"];

		private _ruptureObject = _ruptureClass createVehicle _rupturePos;

		["Rupture Active!"] call zen_common_fnc_showMessage;

		[_ruptureObject, _ruptureAltitude, _spawnInterval] remoteExec [QFUNC(ruptureServer), 2];
	}, {
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _rupturePos] call zen_dialog_fnc_create;

