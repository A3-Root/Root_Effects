#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

private [
	"_slideSpeed", "_slideDistance",
	"_bounceSpeed", "_bounceAltitude",
	"_rotationSpeed", "_rotationClockwise",
	"_orbitRadius", "_orbitSpeed", "_orbitClockwise"
];

params ["_floatingObject", "_slideMove", "_bounceMove", "_rotationMove", "_rollVelocity", "_orbitMove", "_distanceDependent", "_startPos", "_targetAltitude", "_allowDamage", "_allowSimulation"];

_slideSpeed = _slideMove select 0;
_slideDistance = _slideMove select 1;

_bounceSpeed = _bounceMove select 0;
_bounceAltitude = _bounceMove select 1;

_rotationSpeed = _rotationMove select 0;
_rotationClockwise = _rotationMove select 1;

_orbitRadius = _orbitMove select 0;
_orbitSpeed = _orbitMove select 1;
_orbitClockwise = _orbitMove select 2;

_startPos = [getPosATL _floatingObject select 0, getPosATL _floatingObject select 1, _targetAltitude];
_floatingObject setPosATL _startPos;

_floatingObject allowDamage _allowDamage;
_floatingObject enableSimulationGlobal _allowSimulation;

if (_slideSpeed > 0) then {
	[_floatingObject, _slideSpeed, _slideDistance, _distanceDependent, _startPos] spawn {
		params ["_slideObject", "_slideSpeed", "_slideDistance", "_distanceDependent", "_startPos"];

		private _sleepSlide = 0.01;
		private _slideDirection = getDir _slideObject;

		while {true} do {
			while {(player distance _slideObject) < _distanceDependent} do {
				private _travelOffset = 0;
				while {_travelOffset < _slideDistance} do {
					_travelOffset = _travelOffset + _slideSpeed;
					private _newPos = [_startPos, _travelOffset, _slideDirection] call BIS_fncRelPos;
					_slideObject setPosATL _newPos;
					uiSleep _sleepSlide;
				};

				while {_travelOffset > 0} do {
					_travelOffset = _travelOffset - _slideSpeed;
					private _newPos = [_startPos, _travelOffset, _slideDirection] call BIS_fncRelPos;
					_slideObject setPosATL _newPos;			
					uiSleep _sleepSlide;
				};
			};
			waitUntil {(player distance _slideObject) < _distanceDependent};
		};
	};
};

if (_bounceSpeed > 0) then {
	[_floatingObject, _bounceSpeed, _bounceAltitude, _distanceDependent, _startPos, _targetAltitude] spawn {
		params ["_bounceObject", "_bounceSpeed", "_bounceAltitude", "_distanceDependent", "_startPos", "_targetAltitude"];

		private _sleepBounce = 0.01;
		private _altMax = ceil (_targetAltitude + _bounceAltitude);
		private _altMin = ceil (_targetAltitude - _bounceAltitude);

		while {true} do {
			while {(player distance _bounceObject) < _distanceDependent} do {
				private _currentHeight = (getPosATL _bounceObject select 2);
				while {_currentHeight < _altMax} do {
					_currentHeight = _currentHeight + _bounceSpeed;
					_bounceObject setPosATL [_startPos select 0, _startPos select 1, _currentHeight];
					uiSleep _sleepBounce;
				};

				while {_currentHeight > _altMin} do {
					_currentHeight = _currentHeight - _bounceSpeed;
					_bounceObject setPosATL [_startPos select 0, _startPos select 1, _currentHeight];
					uiSleep _sleepBounce;
				};
			};
			waitUntil {(player distance _bounceObject) < _distanceDependent};
		};
	};
};

if (_rotationSpeed > 0) then {
	[_floatingObject, _rotationSpeed, _rotationClockwise, _distanceDependent] spawn {
		params ["_rotationObject", "_rotationSpeed", "_rotationClockwise", "_distanceDependent"];

		private _heading = 0;		
		if (!_rotationClockwise) then {_rotationSpeed = (-1) * _rotationSpeed};

		while {true} do {
			while {(player distance _rotationObject) < _distanceDependent} do {
				_rotationObject setDir _heading;
				uiSleep 0.01;
				_heading = _heading + _rotationSpeed;
				if (_heading == 360) then {_heading = 0};
				if (_heading == 0) then {_heading = 360};
			};
			waitUntil {(player distance _rotationObject) < _distanceDependent};
		};
	};
};

if (_rollVelocity > 0) then {
	[_floatingObject, _rollVelocity, _distanceDependent] spawn {
		params ["_rollObject", "_rollVelocity", "_distanceDependent"];

		private _pitch = 0;

		while {true} do {
			while {(player distance _rollObject) < _distanceDependent} do {
				while {_pitch <= 86.01} do {
					[_rollObject, _pitch, 0] call BIS_fncSetPitchBank;
					_pitch = _pitch + 0.1;
					uiSleep _rollVelocity;
				};
				uiSleep random 0.2;
				while {_pitch > 0.1} do {
					[_rollObject, _pitch, 0] call BIS_fncSetPitchBank;
					_pitch = _pitch - 0.1;
					uiSleep _rollVelocity;
				};
				uiSleep 0.01;
			};
			waitUntil {(player distance _rollObject) < _distanceDependent};
		};
	};
};

if (_orbitRadius > 0) then {
	[_floatingObject, _orbitRadius, _orbitSpeed, _orbitClockwise, _distanceDependent] spawn {
		params ["_orbitObject", "_orbitRadius", "_orbitSpeed", "_orbitClockwise", "_distanceDependent"];

		private _orbitCenter = [getPosATL _orbitObject select 0, getPosATL _orbitObject select 1];
		private _orbitAltitude = getPosASL _orbitObject;

		private ["_orbitAngle", "_directionFactor"];
		if (_orbitClockwise) then {_orbitAngle = 0; _directionFactor = 1} else {_orbitAngle = 360; _directionFactor = -1};

		if (_orbitClockwise) then {
			while {true} do {
				while {(player distance _orbitObject) < _distanceDependent} do {
					private _orbitPos = [_orbitCenter, _orbitRadius, _orbitAngle] call BIS_fncRelPos;
					_orbitObject setPosASL [_orbitPos select 0, _orbitPos select 1, _orbitAltitude select 2];
					_orbitAngle = _orbitAngle + (_directionFactor * _orbitSpeed);
					uiSleep 0.01;
					if (_orbitAngle == 360) then {_orbitAngle = 0};
				};
				waitUntil {(player distance _orbitObject) < _distanceDependent};
			};
		} else {
			while {true} do {
				while {(player distance _orbitObject) < _distanceDependent} do 
				{
					private _orbitPos = [_orbitCenter, _orbitRadius, _orbitAngle] call BIS_fncRelPos;
					_orbitObject setPosASL [_orbitPos select 0, _orbitPos select 1, _orbitAltitude select 2];

					_orbitAngle = _orbitAngle + (_directionFactor * _orbitSpeed);
					if (_orbitAngle == 0) then {_orbitAngle = 360};
					uiSleep 0.01;
				};
				waitUntil {(player distance _orbitObject) < _distanceDependent};
			};
		};
	};
};
