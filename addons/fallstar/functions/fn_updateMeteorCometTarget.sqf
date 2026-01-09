#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};
if (!isNil "meteorCometTarget") exitWith {};

while {true} do {
	private _allUnits = [];
	{
		if (alive _x) then {
			if (typeOf _x != "VirtualCurator_F") then { _allUnits pushBack _x};
		};
	}  forEach (if (isMultiplayer) then {playableUnits} else {switchableUnits});
	meteorCometTarget = selectRandom _allUnits;
	publicVariable "meteorCometTarget"; 
	uiSleep 60;
};
