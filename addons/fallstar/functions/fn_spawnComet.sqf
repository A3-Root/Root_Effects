#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

private _directionOffset = selectRandom [500, -500];
private _startX = (getPos meteorCometTarget select 0) + random _directionOffset;
_directionOffset = selectRandom [500, -500];
private _startY = (getPos meteorCometTarget select 1) + random _directionOffset;
private _startPos = [_startX, _startY, 800];
	
private _cometObject = "Land_Battery_F" createVehicle _startPos;
_cometObject setPosATL _startPos;

private _directionSign = selectRandom [1, -1];	
private _destX = _startX + (random 40000 * _directionSign);
_directionSign = selectRandom [1, -1];
private _destY = _startY + (random 40000 * _directionSign);

[_cometObject] remoteExec [QFUNC(cometGlowEffects), [0, -2] select isDedicated];

_cometObject setVelocity [_destX/100, _destY/100, -1];

uiSleep (4 + random 2);
deleteVehicle _cometObject;
