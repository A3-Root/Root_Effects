// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_main_tracer_object","_colorred","_colorgreen","_colorblue","_activation_distance"];

private ["_trasor","_xx","_yy","_zz","_life_time_tras"];

if (!isNil {_main_tracer_object getVariable "is_ON"}) exitwith {};
_main_tracer_object setVariable ["is_ON", true, true];

al_tracer = true; publicVariable "al_tracer";
al_tracers_sunet_play = false; publicVariable "al_tracers_sunet_play";	

[] spawn {while {al_tracer} do {uiSleep 33 + random 4; al_tracers_sunet_play = false;	publicVariable "al_tracers_sunet_play"}};

[_main_tracer_object,_colorred,_colorgreen,_colorblue,_activation_distance] remoteExec ["Root_fnc_TracersEffects", [0, -2] select isDedicated, true];