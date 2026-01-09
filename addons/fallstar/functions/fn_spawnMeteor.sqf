#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

private ["_destX", "_destY", "_enableShockwave"];

private _directionOffset = selectRandom [1000, -1000];
private _startX = (getPos meteorCometTarget select 0) + random _directionOffset;
_directionOffset = selectRandom [1000, -1000];	
private _startY = (getPos meteorCometTarget select 1) + random _directionOffset;
private _startPos = [_startX, _startY, 800];
_enableShockwave = true;

private _meteorObject = "Land_Battery_F" createVehicle _startPos;
_meteorObject setPosATL _startPos;

[_meteorObject] remoteExec [QFUNC(meteorFlashEffects), [0, -2] select isDedicated];

private _barrierSound = selectRandom ["bariera_1","bariera_2","bariera_3","bariera_4", "bariera_5"];	
[_meteorObject, [_barrierSound, 4000]] remoteExec ["say3D"];

private _directionSign = selectRandom [1000, -1000];	
_destX = _startX + random _directionSign;
_directionSign = selectRandom [1, -1];
_destY = _startY + random _directionSign;

[_meteorObject] remoteExec [QFUNC(meteorTrailEffects), [0, -2] select isDedicated];

_meteorObject setVelocity [_destX/200, _destY/200, -100];
waitUntil {uiSleep 0.1; (getPos _meteorObject select 2) < 20};
private _impactPos = getPos _meteorObject;

[_impactPos, _destX/200, _destY/200, _enableShockwave] remoteExec [QFUNC(meteorImpactEffects), [0, -2] select isDedicated];
deleteVehicle _meteorObject;

private _nearbyObjects = nearestObjects[_impactPos, [], 100];
{
	if((_x isKindOf "LandVehicle") or (_x isKindOf "Man") or (_x isKindOf "Air")) then {
		if (typeOf _x != "VirtualCurator_F") then {
			_x setVelocity [random 3, random 3, random 30];
			if (_x isKindOf "Man") then {
				private _bodyPart = ["RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm", "Head"];
				private _dmgType = selectRandom ["backblast", "explosive", "grenade", "punch", "ropeburn", "shell", "stab"];
				for "_i" from 0 to 5 do { 
					[_x, 0.99, (_bodyPart select _i), _dmgType] call ace_medicalFncAddDamageToUnit;
					_x setDamage [1, false]; 
				}; 
			} else { 
				_x setDamage [1, false]; 
			};
		};
	} else {_x setDamage [1,false]};
} forEach _nearbyObjects;
