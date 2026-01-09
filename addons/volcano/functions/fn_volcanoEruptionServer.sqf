#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 
if (!isServer) exitWith {};

if (!isNil {missionNamespace getVariable "rootEffectsVolcanoRunning"}) exitWith {};
missionNamespace setVariable ["rootEffectsVolcanoRunning", true, true];

params ["_volcanoObject", "_calderaRadius", "_eruptionDelay", "_crater", "_lightningEnabled", "_lava", "_lethal", "_volcanoProtect"];

volcanoProtectionGear =_volcanoProtect; publicVariable "volcanoProtectionGear";

volcanoActive=true;publicVariable "volcanoActive";

[_volcanoObject, _calderaRadius, _eruptionDelay, _lethal] remoteExec [QFUNC(volcanoEruptionEffects), [0, -2] select isDedicated, true];
if (_crater) then {[_volcanoObject, _calderaRadius, _eruptionDelay] remoteExec [QFUNC(volcanoCraterEffects), [0, -2] select isDedicated, true]};
if (_lava) then {[_volcanoObject] remoteExec [QFUNC(volcanoLavaFlow), [0, -2] select isDedicated, true]};

if (_lethal) then {[[9981.46,12077.1,74.964]] spawn FUNC(volcanoUnitDamage);};

if (_eruptionDelay > 0) then 
{
	private _eruptionSoundSets = [
		["eruptie_1", 10, "eruptie_1_eko"],
		["eruptie_2", 4, "eruptie_2_eko"],
		["eruptie_3", 19, "eruptie_3_eko"]
	];
	while {volcanoActive} do 
	{
		private _burstType = selectRandom ["sparks", "shrapnel", "puff"];
		private _eruptionSoundSet = selectRandom _eruptionSoundSets;
		switch (_eruptionSoundSet#0) do {
			case "eruptie_1": {eruptionDuration = _eruptionSoundSet#1; publicVariable "eruptionDuration"; eruptionSound = _eruptionSoundSet#0; publicVariable "eruptionSound"; eruptionEchoSound = _eruptionSoundSet#2; publicVariable "eruptionEchoSound"};
			case "eruptie_2": {eruptionDuration = _eruptionSoundSet#1; publicVariable "eruptionDuration"; eruptionSound = _eruptionSoundSet#0; publicVariable "eruptionSound"; eruptionEchoSound = _eruptionSoundSet#2; publicVariable "eruptionEchoSound"};
			case "eruptie_3": {eruptionDuration = _eruptionSoundSet#1; publicVariable "eruptionDuration"; eruptionSound = _eruptionSoundSet#0; publicVariable "eruptionSound"; eruptionEchoSound = _eruptionSoundSet#2; publicVariable "eruptionEchoSound"};
		};
		uiSleep 1;
		switch (_burstType) do {
			case "shrapnel": {[_volcanoObject, _calderaRadius] remoteExec [QFUNC(volcanoShrapnelBurst), [0, -2] select isDedicated]};
			case "puff": {[_volcanoObject, _calderaRadius] remoteExec [QFUNC(volcanoBlastPuff), [0, -2] select isDedicated]};
			case "sparks": {[_volcanoObject, _calderaRadius] remoteExec [QFUNC(volcanoSparkBurst), [0, -2] select isDedicated]};
		};			
		uiSleep _eruptionDelay;
	};
};
waitUntil {!volcanoActive};
deleteVehicle _volcanoObject;
