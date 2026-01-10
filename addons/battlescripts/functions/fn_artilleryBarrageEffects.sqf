#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_artilleryObject", "_range", "_groundDamage", "_fireDelay", "_shellClass", "_soundOnly", "_nonLethal"];

private _artillerySource = "Land_HelipadEmpty_F" createVehicleLocal getPos _artilleryObject;
"#lightpoint" createVehicleLocal getPos _artillerySource;

while {(artilleryBarrageActive) and (!isNull _artilleryObject)} do {
	
	uiSleep _fireDelay;
	
	private _relPos = [getPos _artilleryObject, random _range, random 360] call BIS_fnc_relPos;

	if (_soundOnly) then {
		_artillerySource setPos _relPos;
		private _groundSound = selectRandom ["explosion_1","explosion_2","explosion_3","explosion_4"];
		_artillerySource say3D [_groundSound, 2000];
		addCamShake [5, 2, 25];
	} else {
		private _nearbyUnits = _relPos nearEntities [["CAManBase", "LandVehicle"], 20];
		private _bomb = _shellClass createVehicleLocal _relPos;
		[_bomb, -90, 0] call BIS_fnc_SetPitchBank;
		_bomb setVelocity [0, 0, -100];
		if (player in _nearbyUnits) then {
			if (_nonLethal) then {
				player allowDamage false;
				player allowDammage false;
				waitUntil {((getPosATL _bomb) select 2 <= 0) || (_bomb == objNull); uiSleep 0.5;};
				uiSleep 0.5;
				player allowDamage true;
				player allowDammage true;
			} else {
				player allowDamage false;
				player allowDammage false;
				waitUntil {((getPosATL _bomb) select 2 <= 0) || (_bomb == objNull); uiSleep 0.5;};
				uiSleep 0.5;
				player allowDamage true;
				player allowDammage true;
				if (isNil "ace_medicalFncAddDamageToUnit") then {
					player setDamage ((damage player) + _groundDamage);
				} else {
					private _bodyPart = selectRandom ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
					[player, _groundDamage, _bodyPart, "explosive"] remoteExec ["ace_medicalFncAddDamageToUnit", player];
					_bodyPart = selectRandom ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
					[player, _groundDamage, _bodyPart, "explosive"] remoteExec ["ace_medicalFncAddDamageToUnit", player];
					_bodyPart = selectRandom ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
					[player, _groundDamage, _bodyPart, "explosive"] remoteExec ["ace_medicalFncAddDamageToUnit", player];
				};
			};
		};
	};
};


/*
playSound3D [ "A3\Sounds_F\arsenal\explosives\grenades\Explosion_HEGrenade01.wss", player, true, ( player getPos [ 15, getDir player ] ) vectorAdd [ 0, 0, 5 ], 5, 1, 0 ];

_emitters = [];

_source1 = createVehicle [ "#particlesource", ( player getPos [ 15, getDir player ] ) vectorAdd [ 0, 0, 5 ], [], 0, "CAN_COLLIDE" ];
_source1 setParticleClass "GrenadeExp";
_source1 setParticleParams [
[
"\A3\data_f\ParticleEffects\Universal\Universal",
16,
0,
32,
0
],
"",
"Billboard",
0.3,
0.3,
[ 0,0,0 ],
[ 0,1,0 ],
0,
10,
7.9,
0.1,
[ 0.0125 * 0.3 + 4, 0.0125 * 0.3 + 1 ],
[ [1,1,1,-6],[1,1,1,0] ],
[ 1 ],
0.2,
0.2,
"",
"",
_this,
0,
false,
0.6,
[ [ 30,30,30,0 ],[ 0,0,0,0 ] ]
];
_source1 setParticleRandom [
0,
[ 0.4,0.1,0.4 ],
[ 0.2,0.5,0.2 ],
90,
0.5,
[ 0,0,0,0 ],
0,
0,
1,
0.0
];
_source1 setParticleCircle [
0,
[ 0,0,0 ]
];
_source1 setParticleFire [1,15,0.1];
_emitters pushBack [ _source1, 0.3 ];

_source2 = createVehicle [ "#particlesource", ( player getPos [ 15, getDir player ] ) vectorAdd [ 0, 0, 5 ], [], 0, "CAN_COLLIDE" ];
_source2 setParticleClass "GrenadeSmoke1";
_source2 setParticleParams [
[
"\A3\data_f\ParticleEffects\Universal\Universal",
16,
9,
1,
0
],
"",
"Billboard",
1,
8,
[ 0,0,0 ],
[ 0,1.5,0 ],
0,
0.0522,
0.04,
0.24,
[ 0.013 * 8 + 3, 0.0125 * 8 + 6, 0.013 * 8 + 8, 0.013 * 8 + 10 ],
[ [0.7,0.7,0.7,0.36],[0.8,0.8,0.8,0.24],[0.85,0.85,0.85,0.14],[0.9,0.9,0.9,0.08],[0.9,0.9,0.9,0.04],[1,1,1,0.01] ],
[ 1000 ],
0.2,
0.2,
"",
"",
_this,
0,
false,
0.6,
[ [ 30,30,30,0 ],[ 0,0,0,0 ] ]
];
_source2 setParticleRandom [
2,
[ 0.8,0.2,0.8 ],
[ 2.5,3.5,2.5 ],
3,
0.4,
[ 0,0,0,0 ],
0.5,
0.02,
1,
0.0
];
_source2 setParticleCircle [
0,
[ 0,0,0 ]
];
_source2 setDropInterval ( 0.08 );
_emitters pushBack [ _source2, 5 ];

_light = createVehicle [ "#lightPoint", ( player getPos [ 15, getDir player ] ) vectorAdd [ 0, 0, 5 ], [], 0, "CAN_COLLIDE" ];
_light setLightAmbient [ 0,0,0 ];
_light setLightBrightness 10;
_light setLightColor [ 1,0.6,0.4 ];
_light setLightIntensity 10000;
_light setLightAttenuation [
0,
0,
0,
2.2,
500,
1000
];
_emitters pushBack [ _light, 0.3 ];

_time = diag_tickTime;
while{ count _emitters > 0 } do {
{
player params[ "_source", "_length" ];
if ( diag_tickTime > _time + _length ) then {
deleteVehicle _source;
_emitters set[ _forEachIndex, objNull ];
};
}forEach _emitters;
_emitters = _emitters - [ objNull ];
};
*/
