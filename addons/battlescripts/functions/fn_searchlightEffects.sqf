#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 



private _setPitchBankYaw = { 
    private ["_object","_rotations","_aroundX","_aroundY","_aroundZ","_dirX","_dirY","_dirZ","_upX","_upY","_upZ","_dir","_up","_dirXTemp","_upXTemp"];
    _object = _this select 0; 
    _rotations = _this select 1; 
    _aroundX = _rotations select 0; 
    _aroundY = _rotations select 1; 
    _aroundZ = (360 - (_rotations select 2)) - 360; 
    _dirX = 0; 
    _dirY = 1; 
    _dirZ = 0; 
    _upX = 0; 
    _upY = 0; 
    _upZ = 1; 
    if (_aroundX != 0) then { 
        _dirY = cos _aroundX; 
        _dirZ = sin _aroundX; 
        _upY = -sin _aroundX; 
        _upZ = cos _aroundX; 
    }; 
    if (_aroundY != 0) then { 
        _dirX = _dirZ * sin _aroundY; 
        _dirZ = _dirZ * cos _aroundY; 
        _upX = _upZ * sin _aroundY; 
        _upZ = _upZ * cos _aroundY; 
    }; 
    if (_aroundZ != 0) then { 
        _dirXTemp = _dirX; 
        _dirX = (_dirXTemp* cos _aroundZ) - (_dirY * sin _aroundZ); 
        _dirY = (_dirY * cos _aroundZ) + (_dirXTemp * sin _aroundZ);        
        _upXTemp = _upX; 
        _upX = (_upXTemp * cos _aroundZ) - (_upY * sin _aroundZ); 
        _upY = (_upY * cos _aroundZ) + (_upXTemp * sin _aroundZ); 		
    }; 
    _dir = [_dirX,_dirY,_dirZ]; 
    _up = [_upX,_upY,_upZ]; 
    _object setVectorDirAndUp [_dir,_up]; 
};

if (!hasInterface) exitWith {};

params ["_searchlightObject", "_enableSound"];

if (_enableSound) then {
	[_searchlightObject] spawn {
		params ["_searchlightObject"];
		while {(alive _searchlightObject) && searchlightActive} do {
			_searchlightObject say3D ["alarma_aerianaScurt",3000];
			uiSleep 30;
		};
	};
};

private _pitch = 30;
private _rotation = 10 + random 350;
while {(alive _searchlightObject) and (searchlightActive)} do 
{
	while {_pitch < 150} do {
	[_searchlightObject,[(-1) * _pitch, 0, _rotation]] call _setPitchBankYaw;
	_pitch = _pitch + 0.2;
	_rotation = _rotation - 0.2;
	uiSleep 0.01;
	};
	uiSleep random 1;
	while {_pitch > 30} do {
	[_searchlightObject, [(-1) * _pitch, 0, _rotation]] call _setPitchBankYaw;
	_pitch = _pitch - 0.2;
	_rotation = _rotation + 1;
	uiSleep 0.01;
	};
};
deleteVehicle _searchlightObject;
deleteVehicle _searchlightObject;
