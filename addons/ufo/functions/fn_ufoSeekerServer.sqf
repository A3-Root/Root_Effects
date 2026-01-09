#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_updateInterval"];
[] spawn FUNC(updateUfoTarget);
waitUntil {!isNil "ufoTargetUnit"};

createMarker ["seekermarker", [0,0,0]];

ufoSeekerActive = true;
while {ufoSeekerActive} do {
	private _targetPos = ufoTargetUnit getRelPos [100 + random 500, selectRandom [random 60, random -60]];
	"seekermarker" setMarkerPos _targetPos;
	["seekermarker"] remoteExec [QFUNC(ufoTravelEffects), [0, -2] select isDedicated];
	uiSleep _updateInterval
}
