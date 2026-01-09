#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

if (!hasInterface) exitWith {};

params ["_startPos"];
private _ufo = "Sign_Sphere200cm_F" createVehicleLocal [0,0,0];
_ufo setObjectTexture [0,"#(argb,8,8,3)color(1,1,1,1,ca)"];
_ufo setPosATL _startPos;
playSound "static";
uiSleep 5;
private _plasmaWave = "#particlesource" createVehicleLocal getPosASL _ufo;  
_plasmaWave setParticleCircle [0,[0,0,0]];  
_plasmaWave setParticleRandom [0,[0,0,0],[0,0,0],0,0,[0,0,0,0],0,0];
_plasmaWave setParticleParams [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.5,[0,0,1],[0,0,0],0,9.999,7,0,[1,50],[[1,1,1,0.2],[1,1,1,0]],[1],0,0,"","",_ufo];
_plasmaWave setDropInterval 0.1;

[_ufo] spawn FUNC(ufoLightChargeEffects);
ufoChargeComplete = false;
playSound3D ["charge_complete", objNull, false, getPos _ufo, 1, 1, 5000];
uiSleep 5;
deleteVehicle _plasmaWave;
ufoChargeComplete = true;
private _chargeLightObject = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosATL _ufo];
_chargeLightObject attachTo [_ufo,[0,150,-2]]; 
deleteVehicle _ufo;
uiSleep 0.5;
deleteVehicle _chargeLightObject;
