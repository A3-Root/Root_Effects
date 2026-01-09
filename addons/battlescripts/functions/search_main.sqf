// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!isServer) exitWith {};

params ["_search_object","_enable_sound"];

if (!isNil {_search_object getVariable "is_ON"}) exitWith {};
_search_object setVariable ["is_ON", true, true];

private _obiect_search = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosASL _search_object];

al_search_light = true; publicVariable "al_search_light";

[_obiect_search, _enable_sound] remoteExec ["Root_fnc_SearchEffects", [0, -2] select isDedicated, true];
