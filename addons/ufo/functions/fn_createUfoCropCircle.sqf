#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if(!isServer) exitWith {};
params ["_ufo", "_radius", "_cropType"];

[_ufo, _radius, _cropType] remoteExec [QFUNC(animateUfoCropCircle), [0, -2] select isDedicated];

uiSleep 5;
ufoCropCircleSoundInitialized = nil;
