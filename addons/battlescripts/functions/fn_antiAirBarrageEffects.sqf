#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_barrageSource", "_range", "_altitude", "_vehicleDamage", "_isLethal", "_burstDelay", "_infantryDamage", "_smokesOnly"];

private ["_nearbyUnits", "_damage", "_vehicleHitPoints"];

_barrageSource setPosATL [getPosATL _barrageSource select 0, getPosATL _barrageSource select 1, _altitude];


private _flakLight = "#lightpoint" createVehicleLocal getPosATL _barrageSource;
if !(_smokesOnly) then {
_flakLight setLightIntensity 0;
_flakLight setLightDayLight true;	
_flakLight setLightUseFlare true;
_flakLight setLightFlareSize 0;
_flakLight setLightAttenuation [1000,0,100,0,1,50];
_flakLight setLightFlareMaxDistance 5000;	
_flakLight setLightAmbient[0.9, 0.9, 0.9];
_flakLight setLightColor[0.9, 0.9, 0.9];
};

private _smokeEmitter = "#particlesource" createVehicleLocal getPosATL _flakLight;
_smokeEmitter setParticleCircle [0,[0,0,0]];
_smokeEmitter setParticleRandom [0.1,[random _range,random _range,random 50],[0,0,0],0,0.1,[0,0,0,0],0,0];
_smokeEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,2,48,0],"", "Billboard",1,1,[0,0,0],[0,0,-1],0,0.01,0.007,0,[1,20],[[1,1,1,1],[1,1,1,1]],[0.8],0,0, "", "", _flakLight];
_smokeEmitter setDropInterval 0.05;

private _smokeColumnEmitter = "#particlesource" createVehicleLocal getPosATL _flakLight;
_smokeColumnEmitter setParticleCircle [0, [0, 0, 0]];
_smokeColumnEmitter setParticleRandom [0.1,[0,0,random 10],[0,0,0],0,0.1,[0,0,0,0],0,0];
_smokeColumnEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, [0,0,0],[0,0,-1], 30, 0.01, 0.007, 0, [5,20,30,40], [[0.6, 0.3, 0.2, 0.5], [0, 0, 0, 0.5], [0, 0, 0, 1], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _flakLight];
_smokeColumnEmitter setDropInterval 0.1;

while {antiAirBarrageActive} do 
{
	private _relativePos = [getPos _barrageSource, random _range, random 360] call BIS_fnc_RelPos;
	private _altitudeOffset = 150 + random 950;
	_flakLight setPosATL [_relativePos select 0, _relativePos select 1, (getPosATL _barrageSource select 2) + ((selectRandom [1,-1]) * (random 50))];
	[_flakLight] spawn 
	{
		private _flakLight = _this select 0;
		private _flakGround = "flak_ground";
		_flakLight say3D [_flakGround, 2000];
	};
	
	uiSleep _burstDelay;
	
	if !(_smokesOnly) then {
		if (_altitudeOffset < 500) then 
		{
			_flakLight setLightFlareSize (10 + random 100);
			_flakLight setLightIntensity (500 + random 500);
		};
	};
	
	private _flakSound = selectRandom ["test_1", "test_2", "test_3", "bariera_1", "bariera_2", "bariera_3", "bariera_4", "bariera_5"];
	_flakLight say3D [_flakSound, 2000];
	_flakLight setLightIntensity 0;

	_nearbyUnits = ((getPosATL _barrageSource) nearEntities [["CAManBase", "Air"], (_range + 5)]) inAreaArray [(getPosATL _barrageSource), (_range * 2), (_range * 2), 0, false, (_altitude / 2)];
	
	if (_isLethal) then {
		{
			private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"] selectRandomWeighted [0.3,0.8,0.65,0.5,0.8,0.65];
			private _dmgType = selectRandom ["backblast", "explosive", "grenade", "burning"];
			if ((typeOf _x != "VirtualCurator_F") && (_x isKindOf "CAManBase") && !(vehicle _x isKindOf "Air")) then {
				if (isNil "ace_medicalFncAddDamageToUnit") then {
					_x setDamage ((damage _x) + _infantryDamage);
				} else { 
					[_x, _infantryDamage, _bodyPart, _dmgType] remoteExec ["ace_medicalFncAddDamageToUnit", _x];	
				}; 
			} else {
				if ((_x isKindOf "ParachuteBase") || (_x isKindOf "BIS_SteerableParachute") || (_x isKindOf "Steerable_ParachuteF")) then {
					private _parachute = _x;
					{
						if (isNil "ace_medicalFncAddDamageToUnit") then {
							_x setDamage ((damage _x) + _infantryDamage);
						} else { 
							[_x, _infantryDamage, _bodyPart, _dmgType] remoteExec ["ace_medicalFncAddDamageToUnit", _x];	
						}; 
					} forEach (crew _parachute);
				} else {
					private _vehicle = _x;
					_damage = random [0, _vehicleDamage, 1];
					_vehicleHitPoints = getAllHitPointsDamage _vehicle; _vehicleHitPoints = _vehicleHitPoints select 0;
					{
						_damage = random [0, _vehicleDamage, 1];
						_vehicle setHitPointDamage [_x, (_vehicle getHitPointDamage _x) + _damage];
					} forEach _vehicleHitPoints;
					_vehicle setHitPointDamage ["HitLight", 1]; 
					_vehicle setHitPointDamage ["#light_l", 1];
					_vehicle setHitPointDamage ["#light_r", 1];
					_vehicle setHitPointDamage ["#light_lFlare", 1];
					_vehicle setHitPointDamage ["#light_rFlare", 1];
					_vehicle setHitPointDamage ["#light_1_hitpoint", 1];
					_vehicle setHitPointDamage ["light_1_hitpoint", 1];
					_vehicle setHitPointDamage ["#light_2_hitpoint", 1];
					_vehicle setHitPointDamage ["light_2_hitpoint", 1];
					_vehicle setHitPointDamage ["light_l", 1]; 
					_vehicle setHitPointDamage ["light_r", 1]; 
					_vehicle setHitPointDamage ["light_l2", 1]; 
					_vehicle setHitPointDamage ["light_r2", 1];
				};
			};
		} forEach _nearbyUnits;
	};
};

deleteVehicle _flakLight;
deleteVehicle _smokeEmitter;
deleteVehicle _smokeColumnEmitter;
