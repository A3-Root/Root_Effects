#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!hasInterface) exitWith {};

params ["_impactPos", "_xVelocity", "_yVelocity", "_enableShockwave"];
private ["_blastEmitter", "_shockwaveEmitter"];

private _splashHot = "#particlesource" createVehicleLocal _impactPos;
_splashHot setParticleCircle [0, [0,0,0]];
_splashHot setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,0,16,1], "", "Billboard", 1, 0.3, [0, 0,0], [0,0,0],5,10,7,0.1, [80,60], [[1,1,1,1],[1,1,1,0]], [1], 1, 0, "", "",_impactPos];
_splashHot setDropInterval 0.1;

private _rockEmitter = "#particlesource" createVehicleLocal _impactPos;
_rockEmitter setParticleCircle [20,[0,0,0]];
_rockEmitter setParticleRandom [7,[0.3,0.3,0],[_xVelocity*5,_yVelocity*5,100],0,0.5,[0, 0, 0, 0.1],0.2,0];
_rockEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1,10, [0, 0, 0], [_xVelocity*2,_yVelocity*2,150],2,200,5,3, [2,2,2], [[0, 0, 0, 1], [0, 0, 0, 0.5], [0.5, 0.5, 0.5, 0]], [0.125],0.5,0, "", "", _impactPos,0,true,0.6,[[0,0,0,0]]];
_rockEmitter setDropInterval 0.005;	

[_splashHot] spawn {
	private _cleanupEmitter = _this select 0;
	uiSleep 0.5;
	deleteVehicle _cleanupEmitter;
};	

if (_enableShockwave) then {
	_blastEmitter = "#particlesource" createVehicleLocal _impactPos;
	_blastEmitter setParticleCircle [0,[0,0,0]];
	_blastEmitter setParticleRandom [0,[0,0,0],[0,0,0],0,0,[0,0,0,0],0,0];
	_blastEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1,2,[0,0,0],[0,0,-100],15,100,3,1,[30,800],[[0.5,0.5,0.5,0.5],[0.5,0.5,0.5,0]],[0.08],0, 0, "", "", _impactPos];
	_blastEmitter setDropInterval 60;
	
	_shockwaveEmitter = "#particlesource" createVehicleLocal _impactPos;
	_shockwaveEmitter setParticleCircle [5,[100,100,0]];
	_shockwaveEmitter setParticleRandom [5,[5,5,0],[-100,-100,0],0,2,[0,0,0,0.5],0,0];
	_shockwaveEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1,5,[0,0,0],[0,0,-5],0,20,1,0.0001,[10,30],[[0,0,0,0.1],[0.5,0.5,0.5,0]],[0.08],0, 0, "", "", _impactPos];
	_shockwaveEmitter setDropInterval 0.00001;
};

private _smokeEmitter = "#particlesource" createVehicleLocal _impactPos;
_smokeEmitter setParticleCircle [40,[0,0,0]];
_smokeEmitter setParticleRandom [0.5,[1,1,0],[50,50,70],3,0.5,[0,0,0,1],1,0];
_smokeEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1,10,[0,0,0],[0,0,20],5,30,5,1,[30,50,100],[[0,0,0,1],[0,0,0,0.5],[0.5,0.5,0.5,0]],[0.08], 1, 0, "", "", _impactPos];
_smokeEmitter setDropInterval 0.01;

private _meteorSoundSource = "land_helipademptyF" createVehicleLocal _impactPos;

[_meteorSoundSource] spawn {
	params ["_meteorSoundSource"];
	private _soundDelay = linearConversion [0,2000,player distance _meteorSoundSource,0,1,true];
	private _shakePower = linearConversion [0,2000,player distance _meteorSoundSource,6,0.1,true];
	uiSleep _soundDelay;
	_meteorSoundSource say3D ["expozie", 3000];
	enableCamShake true;
	addCamShake [_shakePower,5,35];
};

"Crater" createVehicleLocal _impactPos;
private _impactLight = "#lightpoint" createVehicleLocal _impactPos;
_impactLight setLightIntensity 5000;
_impactLight setLightDayLight true;	
_impactLight setLightAttenuation [800,100,10,0,5,800]; 
_impactLight setLightFlareSize 100;
_impactLight setLightFlareMaxDistance 2000;	
_impactLight setLightAmbient[1, 0.5, 0];
_impactLight setLightColor[1, 0.5, 0];
uiSleep 0.2;
if (_enableShockwave) then {deleteVehicle _shockwaveEmitter};
uiSleep 0.2;
deleteVehicle _smokeEmitter;
deleteVehicle _impactLight;
if (_enableShockwave) then {deleteVehicle _blastEmitter};
deleteVehicle _rockEmitter;
playSound "earthquakes";
uiSleep (1 + random 1);
addCamShake [0.5, 30, 35];	
uiSleep 5.3;
enableCamShake false;
deleteVehicle _meteorSoundSource;
