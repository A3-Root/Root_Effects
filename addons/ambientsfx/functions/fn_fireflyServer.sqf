#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_fireflySource", "_fireflyAltitude", "_activationDistance"];

if !(isNil {_fireflySource getVariable QGVAR(isActive)}) exitWith {}; 

_fireflySource setVariable [QGVAR(isActive), true, true];

[_fireflySource, _fireflyAltitude] remoteExec [QFUNC(fireflyEffects), [0, -2] select isDedicated, true];
