#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

private _soundSource = _this select 0;
private _soundName = _this select 1;
private _delaySeconds = _this select 2;
private _maxDistance = _this select 3;

if !(isNil {_soundSource getVariable QGVAR(isActive)}) exitWith {}; 
_soundSource setVariable [QGVAR(isActive), true, true];

if (_delaySeconds < 0) then {
    [_soundSource, [_soundName, _maxDistance]] remoteExec ["say3D"]
} else {
    while {!isNull _soundSource} do {
        [_soundSource, [_soundName, _maxDistance]] remoteExec ["say3D"];
        uiSleep _delaySeconds;
    };
};
