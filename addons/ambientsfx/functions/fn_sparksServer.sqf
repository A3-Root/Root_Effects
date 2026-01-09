#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_lamp", "_altitude", "_sparkDelay"];
private ["_sparkOffset", "_sparkBurstPause"];

if !(isNil {_lamp getVariable QGVAR(isActive)}) exitWith {}; 
_lamp setVariable [QGVAR(isActive), true, true];

while {!isNull _lamp} do 
{
	private _sparkBurstCount = 1 + floor (random 5);
	private _burstIndex = 0;
	while {_burstIndex < _sparkBurstCount} do 
	{
		_sparkBurstPause = 0.1 + (random 2);
		[_lamp, _sparkBurstPause, _altitude] remoteExec [QFUNC(sparksEffectsLoop), [0, -2] select isDedicated];
		uiSleep _sparkBurstPause;
		_burstIndex = _burstIndex + 1;
	};
	uiSleep _sparkDelay;
};
