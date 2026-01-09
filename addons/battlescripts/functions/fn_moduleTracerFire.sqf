#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

// Only run on player machines
if (!hasInterface) exitWith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith
{
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];

private _tracersLoc = getPosATL _logic;
private _radiusPos = getPosATL _logic;
deleteVehicle _logic;

["Tracer Settings",[
	["EDIT",["Tracer Object","Classname of the object used as the weapon generator for Tracers."],["Land_HelipadEmpty_F"]],
	["SLIDER:RADIUS",["Activation Distance","Radius is meters for players to be away to generate tracers."],[1,1000,150,0,_radiusPos,[7,120,32,1]]],
	["COLOR",["Tracer Color","Color of the Tracers."],[1,1,1]]
	
	],{
		params ["_results", "_tracersLoc"];
		_results params ["_tracersObject", "_activationDistance", "_tracerColor"];
		
		private _tracersStart = _tracersObject createVehicle _tracersLoc;
		private _colorRed = _tracerColor select 0;
		private _colorGreen = _tracerColor select 1;
		private _colorBlue = _tracerColor select 2;



		["Tracers Initiated!"] call zen_common_fnc_showMessage;

		[_tracersStart, _colorRed, _colorGreen, _colorBlue, _activationDistance] remoteExec [QFUNC(tracerFireServer), 2];
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _tracersLoc] call zen_dialog_fnc_create;

