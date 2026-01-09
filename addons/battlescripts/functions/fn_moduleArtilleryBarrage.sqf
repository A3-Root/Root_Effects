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

private _groundLoc = getPosATL _logic;
deleteVehicle _logic;

["Ground Barrage Settings",[
	["SLIDER:RADIUS",["Artillery Radius","Radius in meters for the Ground Barrage Area of Effect."],[100,5000,500,0,_groundLoc,[7,120,32,1]]],
	["TOOLBOX:YESNO",["Shake and Sound Only","If true, only explosion sounds and camshake would be generated."],false],
	["TOOLBOX:YESNO",["Non-Lethal Artillery","If true, the barrage will be non-lethal. Mutually Exclusive with Shake and Sound Only."],false],
	["LIST", ["Explosion Type", "Choose the type of explosion created."], [["G_40mm_HE", "M_Mo82mmATLG", "Sh_120mm_APFSDS", "Sh_120mm_HE", "Sh_155mm_AMOS", "HelicopterExploSmall", "HelicopterExploBig", "Bo_GBU12LGB", "Bo_GBU12LGBMI10"], ["40mm High Explosive", "82mm High Explosive", "120mm Armor Piercing Fin Stabilized Discarding Sabot Tank Shell", "120mm High Explosive Shell", "155mm High Explosive Shell", "Small Helicopter Explosion", "Large Helicopter Explosion", "500lb GBU-12 (Type I)", "500lb GBU-12 (Type II)"], 0, 10]],
	["SLIDER:PERCENT", ["Barrage Damage", "Percentage amount of damage the barrage deals."], [0.01, 1, 0.2, 2]],
	["SLIDER",["Fire Delay","Seconds delay at which the barrage fires. Multiplied twice (1 seconds delay = 2 seconds in game). Lower values results in faster rate of fire."],[1,20,1,1]]
	],{
		params ["_results", "_groundLoc"];
		_results params ["_groundRadius", "_soundOnly", "_nonLethal", "_groundType", "_groundDamage", "_groundSpeed"];
		
		private _groundStart = "Land_HelipadEmpty_F" createVehicle _groundLoc;

		["Artillery Barrage Initiated!"] call zen_common_fnc_showMessage;

		[_groundStart, _groundRadius, _groundDamage, _groundSpeed, _groundType, _soundOnly, _nonLethal] remoteExec [QFUNC(artilleryBarrageServer), 2];
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _groundLoc] call zen_dialog_fnc_create;


