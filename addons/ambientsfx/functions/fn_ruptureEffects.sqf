#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_skyObj", "_skyAlt", "_speed"];

_skyObj setPosATL [getPosATL _skyObj select 0, getPosATL _skyObj select 1, _skyAlt];

while {!isNull _skyObj} do 
{
	waitUntil {uiSleep _speed; sunOrMoon == 0};
	private _spRupture = "#particlesource" createVehicleLocal getPosATL _skyObj;
	_spRupture setParticleCircle [0,[0,0,0]];
	_spRupture setParticleRandom [10,[2000,5,5],[0,0,0],0.01,1,[0,0,0,0.1],1,0];
	_spRupture setParticleParams [["\A3\data_f\VolumeLight", 1, 0, 1],"","SpaceObject", 1,180,[0,0,0],[0,0,0],0,9.996,7.84,0,[20,30,20],[[0,0,0,0],[1,1,0.25,1],[0.5,1,0.5,0]],[0.08],1,0,"","",_skyObj];
	_spRupture setDropInterval 0.05;
	waitUntil {uiSleep _speed; sunOrMoon == 1};
	deleteVehicle _spRupture;
};
