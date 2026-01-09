#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

if (!hasInterface) exitWith {};
params ["_ufo"];

private _cloud = "#particlesource" createVehicleLocal getPos _ufo;
_cloud setParticleCircle [0,[0,0,0]];
_cloud setParticleRandom [0,[1500,1500,100],[0,0,0],0,0,[0,0,0,0],0,0];
_cloud setParticleParams[["\A3\data_f\cl_basic", 1, 0, 1],"","Billboard",1,3,[0,0,-1500],[0,0,50],3,10,7.9,0,[400,450,500],[[0.1,0.1,0.5,0],[1,1,1,0.3],[0,0,0.5,0]],[0],0,0,"","",_ufo];
_cloud setDropInterval 0.002;
[_cloud] spawn {params ["_cleanupEmitter"]; uiSleep 0.5; deleteVehicle _cleanupEmitter};

private _crossLight = "#lightpoint" createVehicleLocal getPosATL _ufo;
_crossLight setLightDayLight true; _crossLight setLightUseFlare true;
_crossLight setLightFlareSize 15; _crossLight setLightFlareMaxDistance 5000;	
_crossLight setLightAmbient[0.5,0.5,1];	_crossLight setLightColor[0.443,0.706,0.9];
_crossLight setLightAttenuation [0,0,0,0,0,4000]; 
_crossLight setLightIntensity 10;
_crossLight setLightBrightness 10;

_crossLight attachTo [_ufo, [0,0,0]];
waitUntil {ufoCrossComplete};
if (overcast > 0.5) then {
	_cloud = "#particlesource" createVehicleLocal getPos _ufo;
	_cloud setParticleCircle [0,[0,0,0]];
	_cloud setParticleRandom [0,[1500,1500,100],[0,0,0],0,0,[0,0,0,0],0,0];
	_cloud setParticleParams[["\A3\data_f\cl_basic", 1, 0, 1],"","Billboard",1,3,[0,0,500],[0,0,50],3,10,7.9,0,[400,450,500],[[0.1,0.1,0.5,0],[1,1,1,0.3],[0,0,0.5,0]],[0],0,0,"","",_ufo];
	_cloud setDropInterval 0.002;
	[_cloud] spawn {params ["_cleanupEmitter"]; uiSleep 0.5; deleteVehicle _cleanupEmitter};
};
private _flareSize = 15;
while {_flareSize > 0} do {
	_crossLight setLightFlareSize _flareSize;
	_flareSize = _flareSize - 1;
	uiSleep 0.2;
};
uiSleep 3;
deleteVehicle _crossLight;
