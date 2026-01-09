// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isNil "ufo_hunt_alias") exitWith {};
while {true} do 
{
	private _allunits = [];
	{if ((alive _x) && (typeOf _x != "VirtualCurator_F")) then {_allunits pushBack _x};}  forEach (if (isMultiplayer) then {playableUnits} else {switchableUnits});
	ufo_hunt_alias = selectRandom _allunits; publicVariable "ufo_hunt_alias";
	uiSleep 60;
};
