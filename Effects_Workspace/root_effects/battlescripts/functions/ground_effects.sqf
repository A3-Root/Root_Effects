// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_art_object_name", "_range_art", "_ground_damage", "_ground_speed", "_ground_type", "_sound_only"];

_art_object  = "land_helipadempty_f" createVehiclelocal getpos _art_object_name;
_li_art = "#lightpoint" createVehicleLocal getpos _art_object;

while {(al_art) and (!isNull _art_object_name)} do {
	
	uiSleep _ground_speed;
	
	_rel_Pos = [getPos _art_object_name, random _range_art, random 360] call BIS_fnc_relPos;

	if (_sound_only) then {
		_art_object setPos _rel_Pos;
		_ground_sound = selectRandom ["explosion_1","explosion_2","explosion_3","explosion_4"];
		_art_object say3D [_ground_sound, 2000];
	} else {
		_bomb = _ground_type createVehicle _rel_Pos;
		[_bomb, -90, 0] call BIS_fnc_setPitchBank;
		_bomb setVelocity [0, 0, -100];
	};
};


/*
playSound3D [ "A3\Sounds_F\arsenal\explosives\grenades\Explosion_HE_grenade_01.wss", player, true, ( player getPos [ 15, getDir player ] ) vectorAdd [ 0, 0, 5 ], 5, 1, 0 ];

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
_x params[ "_source", "_length" ];
if ( diag_tickTime > _time + _length ) then {
deleteVehicle _source;
_emitters set[ _forEachIndex, objNull ];
};
}forEach _emitters;
_emitters = _emitters - [ objNull ];
};
*/