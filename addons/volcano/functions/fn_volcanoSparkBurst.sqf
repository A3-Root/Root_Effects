#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};
params ["_volcanoObject", "_craterRadius"];
[_volcanoObject, player] say3D [eruptionSound, 5000];

private _sparkEmitter = "#particlesource" createVehicleLocal position _volcanoObject;
_sparkEmitter setParticleCircle [_craterRadius/3, [0,0,0]];
_sparkEmitter setParticleRandom [0, [0,0,0], [30,30,20], 0, 0, [0,0,0,0], 1, 0];
_sparkEmitter setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal",16,7,48,1],"","Billboard",1,10,[0,0,20],[0,0,50],0,10,8,0,[50,150,200],[[.1,.1,.1,0.5],[0,0,0,1],[0,0,0,0]],[0.5],1,0,"","",_volcanoObject];
_sparkEmitter setDropInterval 0.05;

private _lavaChunkEmitter = "#particlesource" createVehicleLocal position _volcanoObject;
_lavaChunkEmitter setParticleCircle [_craterRadius/4, [0,0,0]];
_lavaChunkEmitter setParticleRandom [4, [_craterRadius/10,_craterRadius/10,10], [80,80,30], 0, 0.1, [0,0,0,1], 1, 1];
_lavaChunkEmitter setParticleParams [["\A3\data_f\cl_exp",1,0,1],"","Billboard",1,2,[10,0,20],[0,0,60],0,30,6,0,[3,1],[[1,1,1,1],[1,1,1,1]],[1],1,1,"","",_volcanoObject];
_lavaChunkEmitter setDropInterval 0.01;

drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,9,0],"","BillBoard",1,7,[0,0,20],[0,0,80],0,500,5,0,[100,200,300],[[1,0.7,0,1],[1,0.7,0,1],[0,0,0,0]],[1],1,0,"","",_volcanoObject];
uiSleep 0.3;
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,9,0],"","BillBoard",1,7,[0,0,10],[0,0,100],0,500,5,0,[100,200,300],[[1,0.7,0,1],[1,0.7,0,1],[0,0,0,0]],[1],1,0,"","",_volcanoObject];

private _earthTremor = selectRandom [["earthquake_03",10],["earthquake_02",25]];
playSound (_earthTremor#0);
enableCamShake true; addCamShake [0.5,(_earthTremor#1)*2,25];
uiSleep 2;
deleteVehicle _lavaChunkEmitter;
deleteVehicle _sparkEmitter;
if ((position player distance _volcanoObject) < 3000) then {playSound eruptionEchoSound};
