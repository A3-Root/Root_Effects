#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_auroraSource", "_auroraAltitude", "_spawnInterval"];

if !(isNil {_auroraSource getVariable "is_auroraON"}) exitWith {}; 

_auroraSource setVariable ["is_auroraON", true, true];

auroraActive = true; publicVariable "auroraActive";

[_auroraSource, _auroraAltitude, _spawnInterval] remoteExec [QFUNC(auroraEffects), [0, -2] select isDedicated, true];
