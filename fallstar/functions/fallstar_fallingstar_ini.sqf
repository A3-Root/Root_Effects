// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

_delay_fall_star = _this select 0;
[] spawn Root_fnc_FallstarHunt;

waitUntil {!isNil "fallstar_hunt_alias"};

alias_fallingstar=true;
publicVariable "alias_fallingstar";

while {alias_fallingstar} do 
{
	[] spawn Root_fnc_FallstarFalling;
	uiSleep _delay_fall_star;
};