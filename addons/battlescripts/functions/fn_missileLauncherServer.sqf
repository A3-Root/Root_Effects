#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_launcherObject", "_minimumDistance", "_launchDelay"];

if (!isNil {_launcherObject getVariable QGVAR(isActive)}) exitWith {};
_launcherObject setVariable [QGVAR(isActive), true, true];

missileLauncherActive = true; publicVariable "missileLauncherActive";

[_launcherObject, _minimumDistance, _launchDelay] remoteExec [QFUNC(missileLauncherEffects), [0, -2] select isDedicated, true];
