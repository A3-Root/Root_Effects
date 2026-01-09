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
deleteVehicle _logic;

["Terminate Effects",[
	["TOOLBOX:YESNO",["Terminate All UFO Encounters","If true, all UFO Encounters will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All UFO Seekers","If true, all UFO Seekers will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All UFO Cropcircles","If true, all UFO Cropcircles will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Meteors","If true, all Meteors will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Comets","If true, all Comets will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Volcano Eruption","If true, all Volcano Eruptions will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All AAA Barrage","If true, all AAA Barrage will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Artillery Barrage","If true, all Artillery Barrage will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Missile Launches","If true, all Missile Launhes will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Tracers","If true, all Tracers will be terminated."],false],
	["TOOLBOX:YESNO",["Terminate All Search Lights","If true, all Search Lights will be terminated."],false]
	// ["TOOLBOX:YESNO",["Terminate All Spacetime Rupture","If true, all Spacetime Ruptures will be terminated."],false]
	// ["TOOLBOX:YESNO",["Terminate All Aurora Borealis","If true, all Aurora Borealis will be terminated."],false]
	],{
		params ["_results"];
		// _results params ["_isencounter", "_isseeker", "_iscropcircles", "_ismeteor", "_iscomet", "_isvolcano", "_isaaa", "_isartillery", "_ismissile", "_istracer", "_issearchlight", "_isrupture", "_isaurora"];
		_results params ["_stopUfoEncounter", "_stopUfoSeeker", "_stopUfoCropCircles", "_stopMeteors", "_stopComets", "_stopVolcano", "_stopAntiAirBarrage", "_stopArtilleryBarrage", "_stopMissileLauncher", "_stopTracerFire", "_stopSearchlights"];

		if (_stopUfoEncounter) then { ufoEncounterActive = false; publicVariable "ufoEncounterActive"; };
		if (_stopUfoSeeker) then { ufoSeekerActive = false; publicVariable "ufoSeekerActive"; };
		if (_stopUfoCropCircles) then { ufoCrossComplete = false; publicVariable "ufoCrossComplete"; };
		if (_stopMeteors) then { meteorsActive = false; publicVariable "meteorsActive"; };
		if (_stopComets) then { cometsActive = false; publicVariable "cometsActive"; };
		if (_stopVolcano) then { volcanoActive = false; publicVariable "volcanoActive"; };
		if (_stopAntiAirBarrage) then { antiAirBarrageActive = false; publicVariable "antiAirBarrageActive"; };
		if (_stopArtilleryBarrage) then { artilleryBarrageActive = false; publicVariable "artilleryBarrageActive"; };
		if (_stopMissileLauncher) then { missileLauncherActive = false; publicVariable "missileLauncherActive"; };
		if (_stopTracerFire) then { tracerFireActive = false; publicVariable "tracerFireActive"; };
		if (_stopSearchlights) then { searchlightActive = false; publicVariable "searchlightActive"; };
		// if (_isrupture == true) then { ruptureActive = false; publicVariable "ruptureActive"; };
		// if (_isaurora == true) then { auroraActive = false; publicVariable "auroraActive"; };
		
		["Effects Terminated!"] call zen_common_fnc_showMessage;
	},{
		["Termination Aborted!"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}] call zen_dialog_fnc_create;
