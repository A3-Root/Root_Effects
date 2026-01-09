// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_freq"];
[] spawn Root_fnc_UFOHunt;
waitUntil {!isNil "ufo_hunt_alias"};

ufoencounter = true;
while {ufoencounter} do {
	private _enc_type = selectRandom ["cross","jump"];
	private _poz = ufo_hunt_alias getRelPos [200 + random 1800, selectRandom [random 60, random -60]];
	private _ini_poz = [_poz#0, _poz#1, 200 + random 1800];
	switch (_enc_type) do {
		case "cross": {[_ini_poz] remoteExec ["Root_fnc_UFOCross", [0, -2] select isDedicated]};
		case "jump": {[_ini_poz] remoteExec ["Root_fnc_UFOLightCharge", [0, -2] select isDedicated]};
	};
	uiSleep _freq;
}
