// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_main_missiles_object", "_missle_distance", "_launch_delay"];

if (!isNil {_main_missiles_object getVariable "is_ON"}) exitwith {};
_main_missiles_object setVariable ["is_ON", true, true];

al_missile = true; publicVariable "al_missile";

[_main_missiles_object, _missle_distance, _launch_delay] remoteExec ["Root_fnc_MissilesEffects", [0, -2] select isDedicated, true];