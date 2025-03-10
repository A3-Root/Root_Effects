// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

// Only run on player machines
if (!hasinterface) exitwith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitwith {
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];

_missile_loc = getPosATL _logic;
deleteVehicle _logic;

["Missile Launcher Settings",[
	["EDIT",["Missile Launcher Object","Classname of the object used as the launch generator for Missile launches."],["Land_HelipadEmpty_F"]],
	["SLIDER:RADIUS",["Minimum Safe Distance","Radius is meters for players to be AWAY to lauch Missiles."],[1,1000,25,0,_radiuspos,[7,120,32,1]]],
	["SLIDER",["Launch Delay","Seconds between each Launch."],[1,100,10,0]]
	],{
		params ["_results", "_missile_loc"];
		_results params ["_missile_object", "_missle_distance", "_launch_delay"];
		
		_missile_start = _missile_object createVehicle _missile_loc;

		["Missile Launcher Initiated!"] call zen_common_fnc_showMessage;

		if (!isNil {_missile_start getVariable "is_ON"}) exitwith {};
		_missile_start setVariable ["is_ON", true, true];

		al_missile = true; publicVariable "al_missile";

		uiSleep _launch_delay;

		_al_rocket = "Land_Battery_F" createVehicleLocal getPosATL _missile_start;

		[[_missile_start, _missle_distance, _al_rocket, _launch_delay], {
			params ["_missile_start", "_missle_distance", "_al_rocket", "_launch_delay"];
			while {(al_missile) and (!isNull _missile_start)} do {
				if (player distance _missile_start > _missle_distance) then {
					_sunetr =  selectRandom ["roc_1","roc_2","roc_3","roc_4"];

					_li = "#lightpoint" createVehiclelocal (getPos _al_rocket);
					_li setLightBrightness 100;
					_li setLightAttenuation [5,0,100,2000,200,500]; 
					_li setLightUseFlare true;
					_li setLightFlareSize 1;
					_li setLightFlareMaxDistance 2000;	
					_li setLightAmbient[1,0.7,0];
					_li setLightColor[1,1,1];
					_li lightAttachObject [_al_rocket, [0,0,-3]];

					_al_rocket say3d [_sunetr,2000];

					_ps1 = "#particlesource" createVehicleLocal getpos _al_rocket;
					_ps1 setParticleCircle [0, [0, 0, 0]];
					_ps1 setParticleRandom [2, [0, 0, 0], [0.2, 0.2, 0.5], 0.3, 0.5, [0, 0, 0, 0.5], 0, 0];
					_ps1 setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2+random 1, [0, 0, 0], [0, 0, 1], 3, 0.01, 0.007, 0, [4,1,7,10], [[1, 1, 1, 1], [0.6, 0.3, 0.2, 1], [0, 0, 0, 0.5], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _al_rocket];
					_ps1 setDropInterval 0.002;

					_al_rocket setVelocity [0,0,200];

					uiSleep _launch_delay;
					deleteVehicle _ps1;	
					deletevehicle _li;
					_al_rocket setPosATL getPosATL _missile_start;
				} else {uiSleep 5};
			};

			deleteVehicle _al_rocket;
		}] remoteExec ["spawn", [0, -2] select isDedicated, true];
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _missile_loc] call zen_dialog_fnc_create;


