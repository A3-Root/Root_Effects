#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_interval"];
[] spawn FUNC(updateUfoTarget);
waitUntil {!isNil "ufoTargetUnit"};

ufoEncounterActive = true;
while {ufoEncounterActive} do {
	private _encounterType = selectRandom ["cross","jump"];
	private _targetPos = ufoTargetUnit getRelPos [200 + random 1800, selectRandom [random 60, random -60]];
	private _startPos = [_targetPos#0, _targetPos#1, 200 + random 1800];
	switch (_encounterType) do {
		case "cross": {[_startPos] remoteExec [QFUNC(ufoCrossFlyby), [0, -2] select isDedicated]};
		case "jump": {[_startPos] remoteExec [QFUNC(ufoLightChargeEffects), [0, -2] select isDedicated]};
	};
	uiSleep _interval;
}
