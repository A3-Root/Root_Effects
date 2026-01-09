#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

params ["_volcanoObject"];

private _lavaFlowPrimary = "#particlesource" createVehicleLocal [(getPosATL _volcanoObject select 0) + random(25), (getPosATL _volcanoObject select 1) + random(25), (getPosATL _volcanoObject select 2) + random(25)];
_lavaFlowPrimary setParticleCircle [20,[0,0,0]];
_lavaFlowPrimary setParticleRandom [5,[5,40,0],[0,0,0],1,0.2,[0,0,0,0.1],1,0];
_lavaFlowPrimary setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal",16,10,32,1],"","Billboard",1,30,[0,0,0],[0,0,-1],1,10,7.9,0,[5,5,10],[[1,1,1,1],[1,1,1,1],[1,1,1,0]],[0.5],1,0, "", "",_volcanoObject];
_lavaFlowPrimary setDropInterval 0.1;
_lavaFlowPrimary setParticleFire [1,50,0.1];

private _lavaFlowSecondary = "#particlesource" createVehicleLocal [(getPosATL _volcanoObject select 0) + random(25), (getPosATL _volcanoObject select 1) + random(25), (getPosATL _volcanoObject select 2) + random(25)];
_lavaFlowSecondary setParticleCircle [20,[0,0,0]];
_lavaFlowSecondary setParticleRandom [5,[15,10,0],[0,0,0],1,0.2,[0,0,0,0.1],1,0];
_lavaFlowSecondary setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal",16,10,32,1],"","Billboard",1,30,[0,0,0],[0,0,-1],1,10,7.9,0,[5,5,10],[[1,1,1,1],[1,1,1,1],[1,1,1,0]],[0.5],1,0, "", "",_volcanoObject];
_lavaFlowSecondary setDropInterval 0.1;

private _lavaFlowTertiary = "#particlesource" createVehicleLocal [(getPosATL _volcanoObject select 0) + random(25), (getPosATL _volcanoObject select 1) + random(25), (getPosATL _volcanoObject select 2) + random(25)];
_lavaFlowTertiary setParticleCircle [20,[0,0,0]];
_lavaFlowTertiary setParticleRandom [5,[3,40,0],[0,0,0],1,0.2,[0,0,0,0.1],1,0];
_lavaFlowTertiary setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal",16,10,32,1],"","Billboard",1,30,[0,0,0],[0,0,-1],1,10,7.9,0,[5,5,10],[[1,1,1,1],[1,1,1,1],[1,1,1,0]],[0.5],1,0, "", "",_volcanoObject];
_lavaFlowTertiary setDropInterval 0.1;
_lavaFlowTertiary setParticleFire [1,50,0.1];

waitUntil {uiSleep 30; !isNull _volcanoObject};
deleteVehicle _lavaFlowPrimary;
deleteVehicle _lavaFlowSecondary;
deleteVehicle _lavaFlowTertiary;
