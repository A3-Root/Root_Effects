// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

private _object_name = _this select 0;
private _sound_name  = _this select 1;
private _delay_sound = _this select 2;
private _distance_au = _this select 3;

if (!isNil {_object_name getVariable "is_ON"}) exitWith {}; 
_object_name setVariable ["is_ON",true,true];

if (_delay_sound < 0) then {
    [_object_name, [_sound_name,_distance_au]] remoteExec ["say3D"]
} else {
    while {!isNull _object_name} do {
        [_object_name, [_sound_name,_distance_au]] remoteExec ["say3D"];
        uiSleep _delay_sound;
    };
};
