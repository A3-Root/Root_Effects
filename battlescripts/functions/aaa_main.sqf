// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_main_air_object", "_main_air_radius", "_main_air_altitude", "_aaa_damage_vic", "_islethal", "_aaa_speed", "_aaa_damage_inf", "_smokesOnly"];

if (!isNil {_main_air_object getVariable "is_ON"}) exitwith {};
_main_air_object setVariable ["is_ON", true, true];

al_aaa = true; publicVariable "al_aaa";

[_main_air_object, _main_air_radius, _main_air_altitude, _aaa_damage_vic, _islethal, _aaa_speed, _aaa_damage_inf, _smokesOnly] remoteExec ["Root_fnc_AAAEffects", [0, -2] select isDedicated, true];
