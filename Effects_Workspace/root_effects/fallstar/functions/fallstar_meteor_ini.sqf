// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

_delay = _this select 0;
[] spawn Root_fnc_FallstarHunt;

waitUntil {!isNil "fallstar_hunt_alias"};

alias_meteors = true;
publicVariable "alias_meteors";

while {alias_meteors} do {
	[] spawn Root_fnc_FallstarMeteor;
	uiSleep _delay;
};