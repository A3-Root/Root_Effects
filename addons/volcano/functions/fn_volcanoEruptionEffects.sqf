// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

#include "..\script_component.hpp"


if (!hasInterface) exitWith {};
params ["_volcanoObject", "_craterRadius", "_eruptionDelay", "_lethal"];

private _idleLight = "#lightpoint" createVehicle getPosATL _volcanoObject;
_idleLight lightAttachObject [_volcanoObject, [0,0,50]];
_idleLight setLightAttenuation [0,0,0,0,40,1000];  
_idleLight setLightIntensity 1500;
_idleLight setLightBrightness 30;
_idleLight setLightDayLight true;	
_idleLight setLightUseFlare true;
_idleLight setLightFlareSize 0;
_idleLight setLightFlareMaxDistance 2000;	
_idleLight setLightAmbient[1,0.2,0.1];
_idleLight setLightColor[1,0.2,0.1];

[_volcanoObject] spawn {params ["_volcanoSource"]; while {!isNull _volcanoSource} do {_volcanoSource say3D ["murmur_8",5000]; uiSleep 60}};

[_idleLight] spawn {private _fireLight = _this select 0; while {!isNull _fireLight} do {_fireLight setLightBrightness (59 + random(40)); _fireLight setLightAttenuation [(1.5 + random(0.5)), (90 + random(10)), (290 + random(10)), 1, (150 + random(100)),1500]; uiSleep 0.1}; deleteVehicle _fireLight};

private _smokeColumnEmitter = "#particlesource" createVehicleLocal getPos _volcanoObject;
_smokeColumnEmitter setParticleCircle [0,[0,0,0]];
_smokeColumnEmitter setParticleRandom [7,[30,30,20],[10,10,15],0,0.5,[0,0,0,0.1],1,0];
_smokeColumnEmitter setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal",16,7,48,1],"","Billboard",1,20,[0,0,30],[0,0,45],0,3,2,0,[50,100,100],[[0,0,0,0.5],[1,1,1,0.5],[0.5,0.5,0.5,0]],[0.5],0.5,0,"",QPATHTOF(functions\fn_volcanoSmokeColumn.sqf),_volcanoObject];
_smokeColumnEmitter setDropInterval 0.05;
