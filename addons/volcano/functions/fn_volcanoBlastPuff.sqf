// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

#include "..\script_component.hpp"

if (!hasInterface) exitWith {};
params ["_volcanoObject", "_craterRadius"];

[_volcanoObject, player] say3D [eruptionSound, 1];
enableCamShake true; addCamShake [0.5, eruptionDuration, 25];

drop [["\a3\Data_f\ParticleEffects\Universal\Universal",16,1,15,1],"","Billboard",0.8,1,[0,0,50],[0,0,100],0,10,8,0,[(_craterRadius/10)*50,(_craterRadius/10)*60,(_craterRadius/10)*2],[[1,1,1,0.5],[1,1,1,1],[1,1,1,1]],[1],1,0,QPATHTOF(functions\fn_volcanoSmokePuff.sqf),"",_volcanoObject];
uiSleep 0.3;
drop [["\a3\Data_f\ParticleEffects\Universal\Universal",16,1,15,0],"","Billboard",1,1,[0,0,50],[0,0,50],0,10,8,0,[(_craterRadius/10)*50,(_craterRadius/10)*60,(_craterRadius/10)*2],[[1,1,1,0],[1,1,1,1],[1,1,1,1]],[1],1,0,"","",_volcanoObject];

private _lavaEmitter = "#particlesource" createVehicleLocal position _volcanoObject;
_lavaEmitter setParticleCircle [_craterRadius/3, [0,0,0]];
_lavaEmitter setParticleRandom [1, [0,0,10], [0,0,0], 0, 0.1, [0,0,0,0], 0, 0];
_lavaEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,9,0],"","BillBoard",1,13,[0,0,50],[0,0,50],0,50,7,0,[_craterRadius*3,_craterRadius*8],[[1,0.7,0,1],[0,0,0,0]],[1],1,0,"","",_volcanoObject];
_lavaEmitter setDropInterval 0.1;
uiSleep 1;
deleteVehicle _lavaEmitter;
private _earthTremor = selectRandom ["earthquake_03", "earthquake_02"];
playSound _earthTremor;
enableCamShake true; addCamShake [0.5, eruptionDuration*2, 25];

if ((position player distance _volcanoObject) < 3000) then {playSound eruptionEchoSound};
