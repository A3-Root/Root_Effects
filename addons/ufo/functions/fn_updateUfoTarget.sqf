#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isNil "ufoTargetUnit") exitWith {};
while {true} do 
{
	private _allunits = [];
	{if ((alive _x) && (typeOf _x != "VirtualCurator_F")) then {_allunits pushBack _x};}  forEach (if (isMultiplayer) then {playableUnits} else {switchableUnits});
	ufoTargetUnit = selectRandom _allunits; publicVariable "ufoTargetUnit";
	uiSleep 60;
};
