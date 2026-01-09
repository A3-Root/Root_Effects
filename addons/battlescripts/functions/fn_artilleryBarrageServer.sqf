#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_artilleryObject", "_artilleryRadius", "_groundDamage", "_fireDelay", "_shellClass", "_soundOnly", "_nonLethal"];

if (!isNil {_artilleryObject getVariable QGVAR(isActive)}) exitWith {};

_artilleryObject setVariable [QGVAR(isActive), true, true];

artilleryBarrageActive = true; publicVariable "artilleryBarrageActive";

[_artilleryObject, _artilleryRadius, _groundDamage, _fireDelay, _shellClass, _soundOnly, _nonLethal] remoteExec [QFUNC(artilleryBarrageEffects), [0, -2] select isDedicated, true];
