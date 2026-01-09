#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_fireflySource", "_fireflyAltitude", "_activationDistance"];

_fireflySource setPosATL [getPosATL _fireflySource select 0, getPosATL _fireflySource select 1, _fireflyAltitude];

while {!isNull _fireflySource} do 
{
	waitUntil {uiSleep 1; sunOrMoon == 0};
	waitUntil {uiSleep 1; player distance _fireflySource < _activationDistance};
	private _fireflyEmitter = "#particlesource" createVehicleLocal (getPosATL _fireflySource);
	_fireflyEmitter setParticleCircle [10,[0,0,0]];
	_fireflyEmitter setParticleRandom [10,[5,5,2],[0.2,0.2,0.5],1,0,[0,0,0,0.1],1,1];
	_fireflyEmitter setParticleParams [["\A3\data_f\proxies\muzzle_flash\mf_machineGunCheetah.p3d",1,0,1],"","SpaceObject",1,14,[0,0,5],[0,0,0.5],13,1.3,1,0,[0.01,0.01],[[1,1,1,1],[1,1,1,1]],[1],1,1,"","",_fireflyEmitter];
	_fireflyEmitter setDropInterval 0.1;
	waitUntil {uiSleep 1; player distance _fireflySource > _activationDistance};
	deleteVehicle _fireflyEmitter;
};
