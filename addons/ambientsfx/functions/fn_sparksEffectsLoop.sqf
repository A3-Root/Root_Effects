#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_lamp", "_emitPause", "_altitude"];

_lamp setPosATL [getPosATL _lamp select 0, getPosATL _lamp select 1, _altitude];

if (player distance _lamp < 200) then {
private _boundingBox = boundingBoxReal vehicle _lamp;
private _boxMin = _boundingBox select 0;
private _boxMax = _boundingBox select 1;
private _maxHeight = abs ((_boxMax select 2) - (_boxMin select 2));

private _sparkOffset = ((_maxHeight / 2) - 0.45);

private _sparkSound = selectRandom ["spark1", "spark3", "spark11", "spark2", "spark22", "spark5", "spark4"];
private _sparkType = selectRandom ["white", "orange"];

private _dropInterval = 0.001 + (random 0.05);

private _sparkEmitter = "#particlesource" createVehicleLocal (getPosATL _lamp);

if (_sparkType == "orange") then 
{
	_sparkEmitter setParticleCircle [0, [0, 0, 0]];
	_sparkEmitter setParticleRandom [1, [0.1, 0.1, 0.1], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
	_sparkEmitter setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flashSilencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1+(random 2), [0, 0,_sparkOffset], [0, 0, 0], 0, 15, 7.9, 0, [0.3,0.3,0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _lamp,0,true,0.3,[[0,0,0,0]]];
	_sparkEmitter setDropInterval _dropInterval;

	_lamp say3D [_sparkSound, 350];
	uiSleep _emitPause;
	deleteVehicle _sparkEmitter;
} else
	{
		_sparkEmitter setParticleCircle [0, [0, 0, 0]];
		_sparkEmitter setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
		_sparkEmitter setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flashSilencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1+(random 2), [0, 0,_sparkOffset], [0, 0, 0], 0, 20, 7.9, 0, [0.3,0.3,0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _lamp,0,true,0.3,[[0,0,0,0]]];
		_sparkEmitter setDropInterval 0.001;	
		_lamp say3D [_sparkSound, 350];
		uiSleep (0.1 + (random 0.4));
		deleteVehicle _sparkEmitter;
	};
};
