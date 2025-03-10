// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

// Only run on player machines
if (!hasinterface) exitwith {};

// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitwith {
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};

params ["_logic"];

_ground_loc = getPosATL _logic;
deleteVehicle _logic;

["Ground Barrage Settings",[
	["SLIDER:RADIUS",["Artillery Radius","Radius in meters for the Ground Barrage Area of Effect."],[100,5000,500,0,_ground_loc,[7,120,32,1]]],
	["TOOLBOX:YESNO",["Shake and Sound Only","If true, only explosion sounds and camshake would be generated."],false],
	["TOOLBOX:YESNO",["Non-Lethal Artillery","If true, the barrage will be non-lethal. Mutually Exclusive with Shake and Sound Only."],false],
	["LIST", ["Explosion Type", "Choose the type of explosion created."], [["G_40mm_HE", "M_Mo_82mm_AT_LG", "Sh_120mm_APFSDS", "Sh_120mm_HE", "Sh_155mm_AMOS", "HelicopterExploSmall", "HelicopterExploBig", "Bo_GBU12_LGB", "Bo_GBU12_LGB_MI10"], ["40mm High Explosive", "82mm High Explosive", "120mm Armor Piercing Fin Stabilized Discarding Sabot Tank Shell", "120mm High Explosive Shell", "155mm High Explosive Shell", "Small Helicopter Explosion", "Large Helicopter Explosion", "500lb GBU-12 (Type I)", "500lb GBU-12 (Type II)"], 0, 10]],
	["SLIDER:PERCENT", ["Barrage Damage", "Percentage amount of damage the barrage deals."], [0.01, 1, 0.2, 2]],
	["SLIDER",["Fire Delay","Seconds delay at which the barrage fires. Multiplied twice (1 seconds delay = 2 seconds in game). Lower values results in faster rate of fire."],[1,20,1,1]]
	],{
		params ["_results", "_ground_loc"];
		_results params ["_ground_radius", "_sound_only", "_nonLethal", "_ground_type", "_ground_damage", "_ground_speed"];
		
		_ground_start = "Land_HelipadEmpty_F" createVehicle _ground_loc;

		["Artillery Barrage Initiated!"] call zen_common_fnc_showMessage;

		private ["_xx","_yy","_zz","_dire"];

		if (!isNil {_ground_start getVariable "is_ON"}) exitwith {};

		_ground_start setVariable ["is_ON",true,true];

		al_art = true; publicVariable "al_art";

		while {(al_art) and (!isNull _ground_start)} do {

			_nearbyUnits = [];
			_nearbyUnits = _groundPos nearEntities [["CAManBase", "LandVehicle"], 20];
			
			uiSleep _ground_speed;
			
			_rel_Pos = [getPos _ground_start, random _ground_radius, random 360] call BIS_fnc_relPos;

			if (_sound_only) then {
				_art_object setPos _rel_Pos;
				_ground_sound = selectRandom ["explosion_1","explosion_2","explosion_3","explosion_4"];
				_art_object say3D [_ground_sound, 2000];
			} else {
				_bomb = _ground_type createVehicle _rel_Pos;
				[_bomb, -90, 0] call BIS_fnc_setPitchBank;
				_bomb setVelocity [0, 0, -100];
				{
					_x allowDamage false;
					_x allowDammage false;
					waitUntil {((getPosATL _bomb) select 2 <= 0) || (_bomb == objNull); uiSleep 0.5;};
					uiSleep 0.5;
					_x allowDamage true;
					_x allowDammage true;
					if !(_nonLethal) then {
						if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
							_bodyPart = selectRandom ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
							[_x, _ground_damage, _bodyPart, "explosive"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
							_bodyPart = selectRandom ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
							[_x, _ground_damage, _bodyPart, "explosive"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
							_bodyPart = selectRandom ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
							[_x, _ground_damage, _bodyPart, "explosive"] remoteExec ["ace_medical_fnc_addDamageToUnit", _x];
						} else {
							_x setDamage ((damage _x) + _ground_damage);
						};
					};
				} forEach _nearbyUnits;
			};
		};
	},{
		["Aborted"] call zen_common_fnc_showMessage;
		playSound "FD_Start_F";
	}, _ground_loc] call zen_dialog_fnc_create;


