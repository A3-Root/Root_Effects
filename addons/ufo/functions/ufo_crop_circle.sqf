// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_ufo", "_radius", "_typ_crop"];

[_ufo,_radius,_typ_crop] remoteExec ["Root_fnc_UFOCropping", [0, -2] select isDedicated];

uiSleep 5;
sunet_ini = nil;