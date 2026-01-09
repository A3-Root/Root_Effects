// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

#include "..\script_component.hpp"

if (!hasInterface) exitWith {};
params ["_volcanoObject", "_craterRadius"];
[_volcanoObject, player] say3D [eruptionSound, 5000];

private _burstEmitter = "#particlesource" createVehicleLocal getPosATL _volcanoObject;
_burstEmitter setParticleCircle [_craterRadius/3, [0,0,0]];
_burstEmitter setParticleRandom [0, [0,0,0], [50,50,20], 0, 0, [0,0,0,0], 1, 0];

_burstEmitter setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal",16,7,48,1],"","Billboard",1,10,[0,0,20],[0,0,50],0,10,8,0,[50,150,200],[[.1,.1,.1,0.5],[0,0,0,1],[0,0,0,0]],[0.5],1,0,"","",_volcanoObject];
_burstEmitter setDropInterval 0.02;

private _rockEmitter = "#particlesource" createVehicleLocal getPosATL _volcanoObject;
_rockEmitter setParticleCircle [_craterRadius/3, [0,0,0]];
_rockEmitter setParticleRandom [5, [10,10,50], [100,100,50], 0.5, 0.5, [0,0,0,1], 1, 0];
if (selectRandom [true,false]) then {
			[] spawn {
				rockTrailProgress = 0;
				while {rockTrailProgress < 50} do {
					rockTrailProgress = rockTrailProgress + 1;
					uiSleep 0.3;
				};
			};
			_rockEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d",1,0,1],"","SpaceObject",0.05,7,[0,0,0],[0,0,150],1,1000,5,0,[8,8,.1],[[0,0,0,1],[0,0,0,1],[0.5,0.5,0.5,1]],[0.125],1,0,QPATHTOF(functions\fn_volcanoRockTrail.sqf),"", _volcanoObject]
		} else {
			_rockEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d",1,0,1],"","SpaceObject",1,7,[0,0,0],[0,0,150],1,1000,5,0,[8,8,.1],[[0,0,0,1],[0,0,0,1],[0.5,0.5,0.5,1]],[0.125],1,0,"","", _volcanoObject]
		};
_rockEmitter setDropInterval 0.05;
uiSleep 0.5;
private _earthTremor = selectRandom [["earthquake_03",10],["earthquake_02",25]];
playSound (_earthTremor#0);
enableCamShake true; addCamShake [0.5,(_earthTremor#1)*2,25];
uiSleep 1;
deleteVehicle _rockEmitter;
uiSleep 1;
deleteVehicle _burstEmitter;
if ((position player distance _volcanoObject) < 3000) then {playSound eruptionEchoSound};
