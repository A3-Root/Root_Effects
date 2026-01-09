#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

params ["_ufo"];
private _satelliteLights = [];
private _angle = 0;
enableCamShake true;

private _chargeLight = "#lightpoint" createVehicleLocal getPosATL _ufo;
_chargeLight setLightDayLight true;_chargeLight setLightUseFlare true;
_chargeLight setLightFlareSize 0; _chargeLight setLightFlareMaxDistance 5000;	
_chargeLight setLightAmbient[0.5,0.5,1];	_chargeLight setLightColor[0.8,0.8,1];
_chargeLight setLightAttenuation [0,0,0,0,0,4000]; 
_chargeLight setLightIntensity 1;
_chargeLight setLightBrightness 1;

while {_angle < 360} do {
	private _ringLight = "#lightpoint" createVehicleLocal (_ufo getRelPos [20,_angle]);
	_ringLight setPos [getPosASL _ringLight #0, getPosASL _ringLight #1, getPosATL _ufo #2];
	_ringLight setLightDayLight true; _ringLight setLightUseFlare true;
	_ringLight setLightFlareSize 5; _ringLight setLightFlareMaxDistance 5000;	
	_ringLight setLightAmbient[0.5,0.5,1];	_ringLight setLightColor[0.8,0.8,1];
	_ringLight setLightAttenuation [0,0,0,0,0,4000];  _ringLight setLightIntensity 0;
	_ringLight setLightBrightness 1;
	_satelliteLights pushBack _ringLight;

	_angle = _angle + 45;
	uiSleep .05;
};

private _chargeIntensity = 0;
while {!ufoChargeComplete} do {

	_chargeIntensity = _chargeIntensity + 0.3;
	_chargeLight setLightFlareSize _chargeIntensity + 20;
	_chargeLight setLightIntensity _chargeIntensity;
	_chargeLight setLightBrightness _chargeIntensity;

	uiSleep 0.05;
};
_chargeLight setLightFlareSize 100;
{deleteVehicle _x} forEach _satelliteLights;
uiSleep 0.5;
_chargeLight setLightFlareSize 0;
_chargeLight setLightIntensity 0;
_chargeLight setLightBrightness 0;
_chargeLight setLightBrightness 200;

uiSleep 0.3;
deleteVehicle _chargeLight;

playSound3D ["final_boom", objNull, false, [getPos player # 0, getPos player # 1, 1000], 10, 1, 5000];
private _leafEmitter = "#particlesource" createVehicleLocal (getPos player);
uiSleep 2.5;
private _dustParticles = "#particlesource" createVehicleLocal (getPos player);
_dustParticles setParticleCircle [20, [-5,-5,0]];
_dustParticles setParticleRandom [1, [0,0,0], [10,10,0],1,0,[0,0,0,0.01],0,0];
_dustParticles setParticleParams [["\A3\data_f\cl_basic",1,0,1],"","Billboard",1,5,[0,0,0],[0,0,0],13,10,8,0.1,[5,10,20],[[0.05,0.04,0.03,0.3],[0.05,0.04,0.03,0.3],[0.05,0.04,0.03,0]],[1],0, 0, "", "", vehicle player];
_dustParticles setDropInterval 0.01;

_leafEmitter setParticleCircle [10,[0,0,0]];
_leafEmitter setParticleRandom [0,[0,0,1],[10,10,10],0.2,0.1,[0,0,0,0],0.5,0.5];
_leafEmitter setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Leaves_Green.p3d",1,0,1],"","SpaceObject",1,7,[0,0,1],[-10,-10,5],7,11,5,0.2,[3,0.1],[[1,1,1,1],[1,1,1,1]],[0],1,1,"","",vehicle player];
_leafEmitter setDropInterval 0.002;
[_leafEmitter] spawn {params ["_cleanupEmitter"]; uiSleep 0.5; deleteVehicle _cleanupEmitter};
[_dustParticles] spawn {params ["_cleanupEmitter"]; uiSleep 0.5; deleteVehicle _cleanupEmitter};
addCamShake [5,4,30];

uiSleep 3;
