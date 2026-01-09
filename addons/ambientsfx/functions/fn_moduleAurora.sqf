#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


/*
object_name - string, the name of the object you use as a source for the SFX
[aurora_1] execvm "AL_ambientSFX\aurora.sqf";
*/

// Only run on player machines
if (!hasInterface) exitWith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith
{
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];

private _auroraPos = getPosATL _logic;

deleteVehicle _logic;

["Ambient Aurora Setting", [
	["EDIT", ["Aurora Object", "Classname of the object to used a source for the SFX."], ["Land_HelipadEmpty_F"]], 
	["SLIDER", ["Aurora Altitude", "Altitude in meters where you want the Aurora."], [1, 4000, 500, 0]],
	["SLIDER", ["Aurora Spawn Speed", "Time taken between each Aurora to spawn in."], [0.1, 20, 0.1, 1]]
	], {
		params ["_results", "_auroraPos"];
		_results params ["_auroraClass", "_auroraAltitude", "_spawnInterval"];
	
		private _auroraObject = _auroraClass createVehicle _auroraPos;

		["Aurora Active!"] call zen_common_fnc_showMessage;

		[_auroraObject, _auroraAltitude, _spawnInterval] remoteExec [QFUNC(auroraServer), 2];
		
	}, {
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _auroraPos] call zen_dialog_fnc_create;

