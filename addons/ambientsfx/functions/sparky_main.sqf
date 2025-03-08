// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_lamp", "_altitude", "_sparksdelay"];
private ["_spark_poz_rel", "_pauza_intre_sclipiri"];

if (!isNil {_lamp getVariable "is_ON"}) exitwith {}; 
_lamp setVariable ["is_ON", true, true];

while {!isNull _lamp} do 
{
	_sclipiri = 1 + floor (random 5);
	_nr = 0;
	while {_nr < _sclipiri} do 
	{
		_pauza_intre_sclipiri = 0.1 + (random 2);
		[_lamp, _pauza_intre_sclipiri, _altitude] remoteExec ["Root_fnc_SparksEffect", [0, -2] select isDedicated];
		uiSleep _pauza_intre_sclipiri;
		_nr = _nr + 1;
	};
	uiSleep _sparksdelay;
};