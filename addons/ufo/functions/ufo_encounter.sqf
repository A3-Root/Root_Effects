// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_freq"];
[] spawn Root_fnc_UFOHunt;
waituntil {!isNil "ufo_hunt_alias"};

ufoencounter = true;
while {ufoencounter} do {
	_enc_type = selectrandom ["cross","jump"];
	_poz = ufo_hunt_alias getrelpos [200 + random 1800, selectrandom [random 60, random -60]];
	_ini_poz = [_poz#0, _poz#1, 200 + random 1800];
	switch (_enc_type) do {
		case "cross": {[_ini_poz] remoteExec ["Root_fnc_UFOCross", [0, -2] select isDedicated]};
		case "jump": {[_ini_poz] remoteExec ["Root_fnc_UFOLightCharge", [0, -2] select isDedicated]};
	};
	uiSleep _freq;
}