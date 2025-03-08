// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_firefly_nest", "_firefly_alt", "_fireflydist"];

if (!isNil {_firefly_nest getVariable "is_ON"}) exitwith {}; 

_firefly_nest setVariable ["is_ON", true, true];

[_firefly_nest, _firefly_alt] remoteExec ["Root_fnc_FireflySfx", [0, -2] select isDedicated, true];