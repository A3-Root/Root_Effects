#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!hasInterface) exitWith {};

params ["_launcherObject", "_minimumDistance", "_launchDelay"];

uiSleep _launchDelay;

private _rocket = "Land_Battery_F" createVehicleLocal getPosATL _launcherObject;

while {(missileLauncherActive) and (!isNull _launcherObject)} do {
	if (player distance _launcherObject > _minimumDistance) then {
		private _rocketSound = selectRandom ["roc_1","roc_2","roc_3","roc_4"];

		private _rocketLight = "#lightpoint" createVehicleLocal (getPos _rocket);
		_rocketLight setLightBrightness 100;
		_rocketLight setLightAttenuation [5,0,100,2000,200,500]; 
		_rocketLight setLightUseFlare true;
		_rocketLight setLightFlareSize 1;
		_rocketLight setLightFlareMaxDistance 2000;	
		_rocketLight setLightAmbient[1,0.7,0];
		_rocketLight setLightColor[1,1,1];
		_rocketLight lightAttachObject [_rocket, [0,0,-3]];

		_rocket say3D [_rocketSound,2000];

		private _smokeEmitter = "#particlesource" createVehicleLocal getPos _rocket;
		_smokeEmitter setParticleCircle [0, [0, 0, 0]];
		_smokeEmitter setParticleRandom [2, [0, 0, 0], [0.2, 0.2, 0.5], 0.3, 0.5, [0, 0, 0, 0.5], 0, 0];
		_smokeEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2+random 1, [0, 0, 0], [0, 0, 1], 3, 0.01, 0.007, 0, [4,1,7,10], [[1, 1, 1, 1], [0.6, 0.3, 0.2, 1], [0, 0, 0, 0.5], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _rocket];
		_smokeEmitter setDropInterval 0.002;

		_rocket setVelocity [0,0,200];

		uiSleep _launchDelay;
		deleteVehicle _smokeEmitter;	
		deleteVehicle _rocketLight;
		_rocket setPosATL getPosATL _launcherObject;
	} else {uiSleep 5};
};

deleteVehicle _rocket;
