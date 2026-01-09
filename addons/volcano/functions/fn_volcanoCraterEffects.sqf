#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if (!hasInterface) exitWith {};
params ["_volcanoObject","_craterRadius"];

private _interiorLava = "#particlesource" createVehicleLocal getPosATL _volcanoObject;
_interiorLava setParticleCircle [0,[0,0,0]];
_interiorLava setParticleRandom [3,[_craterRadius,_craterRadius,10],[0,0,0],5,0.2,[0,0,0,0.1],1,0];
_interiorLava setParticleParams [["\A3\data_f\cl_exp",1,0,1],"","Billboard",1,20,[0,0,30],[0,0,0],3,10.05,7.9,0,[_craterRadius*2,_craterRadius*2+10,_craterRadius*2],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[0.08],1,0,"","",_volcanoObject];
_interiorLava setDropInterval 0.1;

private _lavaHeat = "#particlesource" createVehicleLocal getPosATL _volcanoObject;
_lavaHeat setParticleCircle [0,[0,0,0]];
_lavaHeat setParticleRandom [5,[_craterRadius,_craterRadius,10],[0,0,0],5,0.2,[0,0,0,0.1],1,0];
_lavaHeat setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",1,20,[0,0,30],[0,0,0],5,9.5,7.9,0.5,[_craterRadius*3,_craterRadius*2,_craterRadius],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[1],1,0,"","",_volcanoObject];
_lavaHeat setDropInterval 0.1;

private _lava = "#particlesource" createVehicleLocal position _volcanoObject;
_lava setParticleCircle [_craterRadius/2,[0,0,0]];
_lava setParticleRandom [5,[_craterRadius/4,_craterRadius/4,5],[0,0,0],0,0.1,[0,0,0,0],0,0];
_lava setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,9,0],"","BillBoard",1,10,[0,0,0],[0,0,30],0,80,7,0,[_craterRadius,_craterRadius*5+20],[[1,0.7,0,1],[0,0,0,0]],[1],1,0,"","",_volcanoObject];
_lava setDropInterval 0.7;

private _lavaChunks = "#particlesource" createVehicleLocal position _volcanoObject;
_lavaChunks setParticleCircle [_craterRadius,[0,0,0]];
_lavaChunks setParticleRandom [5,[_craterRadius/6,_craterRadius/6,50],[15,15,20],0,0.1,[0,0,0,1],1,1];
_lavaChunks setParticleParams [["\A3\data_f\cl_exp",1,0,1],"","Billboard",1,5,[0,0,30],[0,0,50],0,30,6,0,[4,.1],[[1,1,1,1],[1,1,1,1]],[1],1,1,"","",_volcanoObject];
_lavaChunks setDropInterval 0.2;

private _lavaBoil = "#particlesource" createVehicleLocal position _volcanoObject;
_lavaBoil setParticleCircle [_craterRadius/3,[0,0,0]];
_lavaBoil setParticleRandom [0,[_craterRadius/6,_craterRadius/6,0],[0.5,0.5,20],0,0.5,[0,0,0,0.1],1,0];
_lavaBoil setParticleParams [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,5,[0,0,0],[0,0,20],0,70,6,0,[_craterRadius,_craterRadius+5,_craterRadius*2],[[1,0.1,0.1,0.5],[1,0.5,0.1,0.3],[1,0.5,0,0]],[1],1,0,"","", _volcanoObject];
_lavaBoil setDropInterval 0.3;

waitUntil {uiSleep 30; isNull _volcanoObject};
deleteVehicle _lavaHeat;
deleteVehicle _lava;
deleteVehicle _interiorLava;
deleteVehicle _lavaChunks;
deleteVehicle _lavaBoil;
