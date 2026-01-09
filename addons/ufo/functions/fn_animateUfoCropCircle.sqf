#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

if (!hasInterface) exitWith {};

private _orbitPattern = {
	params ["_ufo", "_orbitLight", "_orbitSpeed", "_radius", "_crop"];
	private _angle = 0;
	private _placeCounter = 0;
	"Crater" createVehicleLocal getPos _ufo;
	while {_angle < 360} do {
		private _relativePos = _ufo getRelPos [_radius, _angle];
		_orbitLight setPos [_relativePos#0, _relativePos#1, 2];
		drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.3,[0,0,0],[0,0,0],0,9.999,7,0,[1,10],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orbitLight];
		if (_crop && {_placeCounter == 0}) then {
			"Land_ShellCrater02_decal_F" createVehicleLocal _relativePos;
			if (_radius >= 50) then {_placeCounter = 4} else {_placeCounter = 12};
		};
		_placeCounter = _placeCounter - 1;
		_angle = _angle + 1;
		uiSleep _orbitSpeed;
	};
	playSound3D [lans, objNull, false, [getPos _orbitLight # 0, getPos _orbitLight # 1, 100], 10, 1, 3000];
	for "_i" from 1 to 10 do { 
		uiSleep 0.2;
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight];
	};
	drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orbitLight];
	deleteVehicle _orbitLight;
};

private _spiralPattern = {
	params ["_ufo", "_orbitLight", "_orbitSpeed", "_radius", "_crop"];
	private _angle = 0;
	private _placeCounter = 0;
	"Crater" createVehicleLocal getPos _ufo;
	while {_angle < 1260} do {
		private _relativePos = _ufo getRelPos [_radius, _angle];
		_orbitLight setPos [_relativePos#0, _relativePos#1, 2];
		drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.3,[0,0,0],[0,0,0],0,9.999,7,0,[1,10],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orbitLight];
		if (_crop && {_placeCounter == 0}) then {"Land_ShellCrater02_decal_F" createVehicleLocal _relativePos; _placeCounter = 2};
		_placeCounter = _placeCounter - 1;
		_radius = _radius + 0.1;
		_angle = _angle + 1;
		uiSleep _orbitSpeed;
	};
	playSound3D [lans, objNull, false, [getPos _orbitLight # 0, getPos _orbitLight # 1, 100], 10, 1, 3000];
	for "_i" from 1 to 10 do { 
		uiSleep 0.2;
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight];
	};
	drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orbitLight];
	deleteVehicle _orbitLight;
};

private _flowerPattern = {
	private ["_angle", "_orbitMarker", "_petalAngle"];
	params ["_ufo", "_orbitLight", "_orbitSpeed", "_radius", "_crop"];
	_petalAngle = 0;
	"Crater" createVehicleLocal getPos _ufo;
	_orbitMarker = "Sign_Sphere100cm_F" createVehicleLocal [0,0,0];
	_orbitMarker setObjectTextureGlobal [0,"#(argb,8,8,3)color(1,1,1,0,ca)"];
	_orbitMarker setObjectMaterialGlobal [0, "a3\characters_fBootcamp\common\data\vrarmoremmisive.rvmat"];
	while {_petalAngle < 360} do {
		_angle = 360;
		private _relativePos = _ufo getRelPos [_radius, _petalAngle];
		_orbitMarker setPos _relativePos;
		private _placeCounter = 0;
		while {_angle > 0} do {
			private _petalPos = _orbitMarker getRelPos [15, _angle];
			_orbitLight setPos [_petalPos#0, _petalPos#1, 2];
			drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.2,[0,0,0],[0,0,0],0,9.999,7,0,[1,5],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orbitLight];
			if (_crop && {_placeCounter == 0}) then {"Land_ShellCrater02_decal_F" createVehicleLocal getPos _orbitLight; _placeCounter = 18};
			_placeCounter = _placeCounter - 1;
			_angle = _angle - 1;
			if ((_angle < 10) || (_angle > 349)) then {drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.3,1,[1,1,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight]};
			uiSleep _orbitSpeed;
		};
		_petalAngle = _petalAngle + 30;
	};
	playSound3D [lans, objNull, false, [getPos _orbitLight # 0, getPos _orbitLight # 1, 100], 10, 1, 3000];
	for "_i" from 1 to 10 do { 
		uiSleep 0.2;
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight];
	};
	drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orbitLight];
	deleteVehicle _orbitLight;
	deleteVehicle _orbitMarker;
};

params ["_ufo", "_radius", "_cropType"];
enableCamShake true;
if (isNil "ufoCropCircleSoundInitialized") then {
	playSound3D ["aterizat", objNull, false, [getPos _ufo select 0, getPos _ufo select 1, 200], 10, 1, 0];
	[] spawn {
		uiSleep 3.9;
		addCamShake [2,10,30];
		playSound "cutremur";
	};
	ufoCropCircleSoundInitialized = true;
};
uiSleep 1.3;
private _orbitLight = "#lightpoint" createVehicleLocal [0,0,0];
_orbitLight setLightDayLight true;_orbitLight setLightUseFlare true;
_orbitLight setLightFlareSize 5; _orbitLight setLightFlareMaxDistance 5000;	
_orbitLight setLightAmbient[0.5,0.5,1]; _orbitLight setLightColor[0.443,0.706,0.9];
_orbitLight setLightAttenuation [0,0,0,0,0,4000]; 
_orbitLight setLightBrightness 5;

drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,500],[0,0,-200],0,9,7,0,[1,10],[[0,0,1,1],[0.9,.9,1,1]],[1],0,0,"","",_ufo];
uiSleep 2;
for "_i" from 1 to 3 do { 
	uiSleep 0.1;
	drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight];
};
uiSleep 0.3;
private _shockwaveEmitter = "#particlesource" createVehicleLocal getPos _ufo;
_shockwaveEmitter setParticleCircle [5,[0,0,0]];
_shockwaveEmitter setParticleRandom [0.1,[3,3,1],[100,100,0],0,2,[0,0,0,0.5],1,0];
_shockwaveEmitter setParticleParams [["\A3\data_f\cl_basic",1,0,1],"","Billboard",1,3,[1,1,2],[0,0,-5],0,20,1,1,[5,10],[[0,0,0,0.3],[0.1,0.1,0.1,0]],[1],1,0,"","",_ufo];
_shockwaveEmitter setDropInterval 0.002;
[_shockwaveEmitter] spawn {private _cleanupEmitter = _this select 0; uiSleep 0.2; deleteVehicle _cleanupEmitter};
switch (_cropType) do {
	case "circle": {[_ufo, _orbitLight, 0.01, _radius, true] spawn _orbitPattern};
	case "spiral": {[_ufo, _orbitLight, 0.01, _radius, true] spawn _spiralPattern};
	case "flower": {[_ufo, _orbitLight, 0.01, _radius, true] spawn _flowerPattern};
};
while {alive _orbitLight} do {
	_orbitLight say3D ["crop_me", 2000];
	uiSleep 17;
};
