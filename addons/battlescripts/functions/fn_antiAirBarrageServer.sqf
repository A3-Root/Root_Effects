#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_barrageObject", "_range", "_altitude", "_vehicleDamage", "_isLethal", "_burstDelay", "_infantryDamage", "_smokesOnly"];

if (!isNil {_barrageObject getVariable QGVAR(isActive)}) exitWith {};
_barrageObject setVariable [QGVAR(isActive), true, true];

antiAirBarrageActive = true; publicVariable "antiAirBarrageActive";

[_barrageObject, _range, _altitude, _vehicleDamage, _isLethal, _burstDelay, _infantryDamage, _smokesOnly] remoteExec [QFUNC(antiAirBarrageEffects), [0, -2] select isDedicated, true];
