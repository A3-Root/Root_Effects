#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_spawnInterval"];
[] spawn FUNC(updateMeteorCometTarget);

waitUntil {!isNil "meteorCometTarget"};

meteorsActive = true;
publicVariable "meteorsActive";

while {meteorsActive} do {
	[] spawn FUNC(spawnMeteor);
	uiSleep _spawnInterval;
};
