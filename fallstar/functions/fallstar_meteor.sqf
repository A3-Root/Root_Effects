// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

private ["_xx_dest","_yy_dest","_blast"];

_dire	= selectRandom [1000, -1000];
_xx = (getpos fallstar_hunt_alias select 0) + random _dire;
_dire	= selectRandom [1000, -1000];	
_yy = (getpos fallstar_hunt_alias select 1) + random _dire;
_poz_ini = [_xx, _yy, 800];
_blast = true;

_falling_meteor_main = "Land_Battery_F" createVehicle _poz_ini;
_falling_meteor_main setPosATL _poz_ini;

[_falling_meteor_main] remoteExec ["Root_fnc_FallstarMeteorBlast", [0, -2] select isDedicated];

_bariera_sunet = selectRandom ["bariera_1","bariera_2","bariera_3","bariera_4", "bariera_5"];	
[_falling_meteor_main,[_bariera_sunet,4000]] remoteExec ["say3d"];

_dire_dest	= selectRandom [1000, -1000];	
_xx_dest 	= _xx + random _dire_dest;
_dire_dest	= selectRandom [1, -1];
_yy_dest 	= _yy + random _dire_dest;

[_falling_meteor_main] remoteExec ["Root_fnc_FallstarMeteorEffect", [0, -2] select isDedicated];

_falling_meteor_main setvelocity [_xx_dest/200, _yy_dest/200, -100];
waitUntil {uiSleep 0.1; (getpos _falling_meteor_main select 2) < 20};
_poz_end = getPos _falling_meteor_main;

[_poz_end,_xx_dest/200, _yy_dest/200, _blast] remoteExec ["Root_fnc_FallstarMeteorEnd", [0, -2] select isDedicated];
deleteVehicle _falling_meteor_main;

_nearobjects = nearestObjects[_poz_end,[],100];
{
	if((_x isKindOf "LandVehicle") or (_x isKindOf "Man") or (_x isKindOf "Air")) then {
		if (typeOf _x != "VirtualCurator_F") then {
			_x setVelocity [random 3, random 3, random 30];
			if (_x isKindOf "Man") then {
				_bodyPart = ["RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm", "Head"];
				_dmgType = selectRandom ["backblast", "explosive", "grenade", "punch", "ropeburn", "shell", "stab"];
				for (_i from 0 to 5) do { 
					[_x, 0.99, (_bodyPart select _i), _dmgType] call ace_medical_fnc_addDamageToUnit;
					_x setDamage [1, false]; 
				}; 
			} else { 
				_x setdamage [1, false]; 
			};
		};
	} else {_x setdamage [1,false]};
} foreach _nearobjects;
