#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!hasInterface) exitWith {};

private _meteorObject = _this select 0;

private _trailLight = "#lightpoint" createVehicle getPos _meteorObject;
_trailLight setLightBrightness 90;
_trailLight setLightDayLight true;
_trailLight setLightAmbient[1,0.5,0];
_trailLight setLightColor[1, 0.5, 0];
_trailLight lightAttachObject [_meteorObject, [0,0,0.1]];

private _smokeEmitter  = "#particlesource" createVehicleLocal getPosATL _meteorObject;
_smokeEmitter  setParticleCircle [0,[0,0,0]];
_smokeEmitter  setParticleRandom [0,[0,0,0],[0,0,0],0,0,[0,0,0,0],0,0];
_smokeEmitter  setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,3,17,1], "", "Billboard", 1,0.5,[0, 0, 0], [0, 0, 0.5],5, 10.1, 7.9, 0.0001, [7,3,1], [[0.1,0.1,0.1,0.9], [0.6,0.6,0.6,0.6], [0.8,0.8,0.8,0.4],[0.9,0.9,0.9,0.3],[1,1,1,0.1]],[500], 1, 0, "", "", _meteorObject];	
_smokeEmitter  setDropInterval 0.002;

private _sparkEmitter = "#particlesource" createVehicleLocal getPosATL _meteorObject;
_sparkEmitter setParticleCircle [0, [0, 0, 0]];
_sparkEmitter setParticleRandom [0.5,[1,1,0],[0.175,0.175,0],5,0.25,[0,0,0,0.5],1,0];
_sparkEmitter setParticleParams [["\A3\data_f\cl_basic",1,0,1], "", "Billboard",1,7,[0,0,3],[0,0,0],7,10,7.9,0.1,[10,20,50],[[0,0,0,1],[0,0,0,1],[0,0,0,0]],[0.08], 1, 0, "", "", _meteorObject];
_sparkEmitter setDropInterval 0.01;

while {!isNull _meteorObject} do 
{
	_meteorObject say3D ["meteor_1",2000];
	uiSleep 0.9;
};
deleteVehicle _trailLight;
