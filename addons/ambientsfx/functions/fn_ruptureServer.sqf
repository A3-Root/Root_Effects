#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_skyObj", "_skyAlt", "_speed"];

if (!isNil {_skyObj getVariable "is_ruptureON"}) exitWith {}; 
_skyObj setVariable ["is_ruptureON", true, true];

ruptureActive = true; publicVariable "ruptureActive";

[_skyObj, _skyAlt, _speed] remoteExec [QFUNC(ruptureEffects), [0, -2] select isDedicated, true];
