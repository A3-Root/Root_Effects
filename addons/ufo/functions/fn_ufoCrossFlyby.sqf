#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if(!isServer) exitWith {};
params ["_startPos"];
private _ufoObject = "Land_Battery_F" createVehicle [0,0,0];
ufoCrossComplete = false; publicVariable "ufoCrossComplete";
_ufoObject setPosATL [_startPos#0, _startPos#1, 3000];
_ufoObject setVelocity [0, 0, -300];
[_ufoObject] remoteExec [QFUNC(ufoCrossLighting), [0, -2] select isDedicated];
uiSleep 8;
[_ufoObject, ["ufo_cross", 3000]] remoteExec ["say3D"];
private _zigzagCount = 2 + round (random 10);
while {_zigzagCount > 0} do {
	_ufoObject setVelocity [200 + round (random 200) * selectRandom[-1, 1], 200, 1];
	uiSleep (1 + round (random 2));
	_zigzagCount = _zigzagCount - 1;
};
_ufoObject setVelocity [0, 0, 500];
ufoCrossComplete = true; publicVariable "ufoCrossComplete";
uiSleep 6;
deleteVehicle _ufoObject;
