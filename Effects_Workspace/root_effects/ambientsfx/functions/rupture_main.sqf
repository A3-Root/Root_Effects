// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_sky_obj", "_sky_alt", "_speed"];

if (!isNil {_sky_obj getVariable "is_ruptureON"}) exitwith {}; 
_sky_obj setVariable ["is_ruptureON", true, true];

rupture_active = true; publicVariable "rupture_active";

[_sky_obj, _sky_alt, _speed] remoteExec ["Root_fnc_RuptureSfx", [0, -2] select isDedicated, true];