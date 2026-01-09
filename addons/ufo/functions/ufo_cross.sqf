// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if(!isServer) exitWith {};
private ["_cross_ufo"];
params ["_poz_ini"];
_cross_ufo = "Land_Battery_F" createVehicle [0,0,0];
end_cross = false; publicVariable "end_cross";
_cross_ufo setPosATL [_poz_ini#0, _poz_ini#1, 3000];
_cross_ufo setVelocity [0, 0, -300];
[_cross_ufo] remoteExec ["Root_fnc_UFOCrossLit", [0, -2] select isDedicated];
uiSleep 8;
[_cross_ufo,["ufo_cross", 3000]] remoteExec ["say3D"];
private _zig = 2 + round (random 10);
while {_zig > 0} do {
	_cross_ufo setVelocity [200 + round (random 200) * selectRandom[-1, 1], 200, 1];
	uiSleep (1 + round (random 2));
	_zig = _zig - 1;
};
_cross_ufo setVelocity [0, 0, 500];
end_cross = true; publicVariable "end_cross";
uiSleep 6;
deleteVehicle _cross_ufo;
