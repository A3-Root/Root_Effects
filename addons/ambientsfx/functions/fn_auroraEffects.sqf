#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_auroraSource", "_auroraAltitude", "_spawnInterval"];

_auroraSource setPosATL [getPosATL _auroraSource select 0, getPosATL _auroraSource select 1, _auroraAltitude];

while {!isNull _auroraSource} do 
{
	waitUntil {uiSleep _spawnInterval; sunOrMoon == 0};
	private _plasmaWave = "#particlesource" createVehicleLocal (getPosATL _auroraSource);  
	_plasmaWave setParticleCircle [0,[0,0,0]];  
	_plasmaWave setParticleRandom [5,[2500,20,10],[0,0,0],10,0,[0,0,0,0],1,0];  
	_plasmaWave setParticleParams [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,180,[0,0,0],[0,0,0],13,9.999,7.9,0.005,[150,150,150,300],[[0,1,0,0],[0,1,0,1],[0,0.3,0.7,0.5],[0.9,0,0.7,1],[0.4,0,0.2,0]],[0.08],1,0,"","",_auroraSource];
	_plasmaWave setDropInterval 0.05;
	waitUntil {uiSleep _spawnInterval; sunOrMoon == 1};
	deleteVehicle _plasmaWave;
};
