// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

_dire	= selectRandom [500, -500];
_xx = (getpos fallstar_hunt_alias select 0) + random _dire;
_dire	= selectRandom [500, -500];
_yy = (getpos fallstar_hunt_alias select 1) + random _dire;
_poz_ini = [_xx, _yy, 800];
	
_falling_star_main = "Land_Battery_F" createVehicle _poz_ini;
_falling_star_main setPosATL _poz_ini;

_dire_dest	= selectRandom [1, -1];	
_xx_dest 	= _xx + (random 40000 * _dire_dest);
_dire_dest	= selectRandom [1, -1];
_yy_dest 	= _yy + (random 40000 * _dire_dest);

[_falling_star_main] remoteExec ["Root_fnc_FallstarLumina", [0, -2] select isDedicated];

_falling_star_main setvelocity [_xx_dest/100, _yy_dest/100, -1];

uiSleep 4 + random 2;
deleteVehicle _falling_star_main;