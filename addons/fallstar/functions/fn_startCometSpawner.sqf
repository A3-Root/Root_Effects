#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_spawnInterval"];
[] spawn FUNC(updateMeteorCometTarget);

waitUntil {!isNil "meteorCometTarget"};

cometsActive=true;
publicVariable "cometsActive";

while {cometsActive} do 
{
	[] spawn FUNC(spawnComet);
	uiSleep _spawnInterval;
};
