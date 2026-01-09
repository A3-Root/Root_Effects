#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_searchlightSource", "_enableSound"];

if (!isNil {_searchlightSource getVariable QGVAR(isActive)}) exitWith {};
_searchlightSource setVariable [QGVAR(isActive), true, true];

private _searchlightObject = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosASL _searchlightSource];

searchlightActive = true; publicVariable "searchlightActive";

[_searchlightObject, _enableSound] remoteExec [QFUNC(searchlightEffects), [0, -2] select isDedicated, true];
