#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

private _effectPos = _this;
private _smokeEmitter = "#particlesource" createVehicleLocal [_effectPos select 0, _effectPos select 1, _effectPos select 2];
_smokeEmitter setParticleCircle [20,[0,0,0]];
_smokeEmitter setParticleRandom [0,[0,0,0],[50,50,0],0,0,[0,0,0,0],0,0];
_smokeEmitter setParticleParams [["\A3\data_f\cl_basic.p3d",1,0,1],"","Billboard",1,10,[0,0,0],[0,0,30],3,150,1,0,[50,100,150],[[.1,.1,.1,1],[0,0,0,1],[0,0,0,0]],[1000],1,0,"","",[_effectPos select 0, _effectPos select 1, _effectPos select 2]];
_smokeEmitter setDropInterval 0.005;

private _earthTremor = selectRandom [["earthquake_03",10],["earthquake_02",25]];
playSound (_earthTremor#0);
enableCamShake true; addCamShake [0.5,(_earthTremor#1)*2,25];
uiSleep 0.5;
deleteVehicle _smokeEmitter;
uiSleep 1.5;
if ((position player distance _effectPos) < 3000) then {playSound eruptionEchoSound};
