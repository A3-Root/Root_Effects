#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_mainTracerObject", "_colorRed", "_colorGreen", "_colorBlue", "_activationDistance"];

if (!isNil {_mainTracerObject getVariable QGVAR(isActive)}) exitWith {};
_mainTracerObject setVariable [QGVAR(isActive), true, true];

tracerFireActive = true; publicVariable "tracerFireActive";
tracerSoundPlayed = false; publicVariable "tracerSoundPlayed";	

[] spawn {while {tracerFireActive} do {uiSleep (33 + random 4); tracerSoundPlayed = false;	publicVariable "tracerSoundPlayed"}};

[_mainTracerObject, _colorRed, _colorGreen, _colorBlue, _activationDistance] remoteExec [QFUNC(tracerFireEffects), [0, -2] select isDedicated, true];
