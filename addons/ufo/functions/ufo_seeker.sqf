// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_freq"];
[] spawn Root_fnc_UFOHunt;
waitUntil {!isNil "ufo_hunt_alias"};

private _seekermarker = createMarker ["seekermarker", [0,0,0]];

seekeron = true;
while {seekeron} do {
	private _poz = ufo_hunt_alias getRelPos [100 + random 500, selectRandom [random 60, random -60]];
	"seekermarker" setMarkerPos _poz;
	["seekermarker"] remoteExec ["Root_fnc_UFOTravel", [0, -2] select isDedicated];
	uiSleep _freq
}
