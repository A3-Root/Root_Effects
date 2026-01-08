// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_sky_obj", "_sky_alt", "_speed"];

if (!isNil {_sky_obj getVariable "is_auroraON"}) exitwith {}; 

_sky_obj setVariable ["is_auroraON", true, true];

aurora_active = true; publicVariable "aurora_active";

[_sky_obj, _sky_alt, _speed] remoteExec ["Root_fnc_AuroraSfx", [0, -2] select isDedicated, true];