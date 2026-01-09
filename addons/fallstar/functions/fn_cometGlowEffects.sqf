#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!hasInterface) exitWith {};

	params ["_cometObject"];

	private _smokeEmitter = "#particlesource" createVehicleLocal getPosATL _cometObject;
	_smokeEmitter setParticleCircle [0, [0, 0, 0]];
	_smokeEmitter setParticleRandom [3, [0.25, 0.25, 0.25], [0, 0, 0], 0, 0.25, [0, 0, 0, 0.5], 0, 0];	
	_smokeEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0.75], 30, 10, 7.9, 0, [1.2, 4, 1], [[1, 1, 1, 1], [0.25, 0.25, 0.25, 0.5]], [0.08], 1, 0, "", "", _cometObject];
	_smokeEmitter setDropInterval 0.002;	
	
	private _brightness = 3000;
	private _cometLight = "#lightpoint" createVehicle [(getPos _cometObject select 0), (getPos _cometObject select 1), (getPos _cometObject select 2)];
	_cometLight lightAttachObject [_cometObject, [0,0,0]];
	_cometLight setLightIntensity _brightness;
	_cometLight setLightAttenuation [500,300,3000,0,5,500]; 
	_cometLight setLightUseFlare true;
	_cometLight setLightFlareSize 10;
	_cometLight setLightFlareMaxDistance 2000;	
	_cometLight setLightAmbient[1,.8,.7];
	_cometLight setLightColor[1,1,1];	
	
	uiSleep 0.2;
	
	_cometLight setLightFlareSize 5;

	while {_brightness > -50} do {
		_cometLight setLightIntensity _brightness;
		_brightness = _brightness - 50;
	uiSleep 0.05;
	};
	waitUntil {_brightness == 0};
	deleteVehicle _cometLight;
