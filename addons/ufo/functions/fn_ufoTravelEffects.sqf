#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

if (!hasInterface) exitWith {};
params ["_ufoMarker"];
enableCamShake true;
playSound3D ["aterizat",objNull,false,[getMarkerPos _ufoMarker#0, getMarkerPos _ufoMarker#1, 200], 10, 1, 3000];
uiSleep 1.3;
private _orbitMarker = "Sign_Sphere100cm_F" createVehicleLocal getMarkerPos _ufoMarker;
_orbitMarker setObjectTextureGlobal [0,"#(argb,8,8,3)color(1,1,1,0,ca)"];
drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,500],[0,0,-200],0,9,7,0,[1,10],[[0,0,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orbitMarker];
uiSleep 2;
for "_i" from 1 to 3 do { 
	uiSleep 0.1;
	drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitMarker];
};
private _shockwaveEmitter = "#particlesource" createVehicleLocal getPosATL _orbitMarker;
_shockwaveEmitter setParticleCircle [5,[0,0,0]];
_shockwaveEmitter setParticleRandom [0.1,[3,3,1],[100,100,0],0,2,[0,0,0,0.5],1,0];
_shockwaveEmitter setParticleParams [["\A3\data_f\cl_basic",1,0,1],"","Billboard",1,3,[1,1,2],[0,0,-5],0,20,1,1,[5,10],[[0.05,0.04,0.03,0.5],[0.05,0.04,0.03,0]],[1],1,0,"","",_orbitMarker];
_shockwaveEmitter setDropInterval 0.002;
[_shockwaveEmitter] spawn {private _cleanupEmitter = _this select 0;uiSleep 0.2; deleteVehicle _cleanupEmitter};
"Crater" createVehicleLocal getPos _orbitMarker;
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,9,0],"","BillBoard",1,3,[0,0,1],[0,0,10],0,50,0.01,0,[10,25],[[0.1,0.1,0.1,1],[0.1,0.1,0.1,1]],[1000],1,0,"","",_orbitMarker];
uiSleep 0.3;

private _orbitLight = "#lightpoint" createVehicleLocal getMarkerPos _ufoMarker;
_orbitLight setLightDayLight true;_orbitLight setLightUseFlare true;
_orbitLight setLightFlareSize 5; _orbitLight setLightFlareMaxDistance 5000;	
_orbitLight setLightAmbient[0.5,0.5,1]; _orbitLight setLightColor[0.5,0.7,0.9];
_orbitLight setLightAttenuation [0,0,0,0,0,4000]; 
_orbitLight setLightBrightness 10;
private _orbitSpeed = 0.02;

private _jumpCount = 4 + round (random 33);
[_orbitLight] spawn {
	params ["_orbitLight"];
	while {alive _orbitLight} do {
		_orbitLight say3D ["charge_2", 400];
		uiSleep 4;
	}
};
addCamShake [2, 10, 30];
playSound "cutremur";
while {_jumpCount > 0} do {
	private _radius = 5 + round (random 20);
	private _relativePos = _orbitMarker getRelPos [_radius, round (random 360)];
	_orbitMarker setPos _relativePos;
	private _clockwise = selectRandom [true,false];
	private _rotationAngle = _orbitMarker getRelDir _orbitLight;
	private _orbitRadius = _orbitLight distance _orbitMarker;
	private _arcSteps = round (random 180);
	while {_arcSteps > 0} do {
		private _relativePosInner = _orbitMarker getRelPos [_orbitRadius, _rotationAngle];
		_orbitLight setPos [_relativePosInner#0, _relativePosInner#1, 2];
		drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,1,[0,0,0],[0,0,0],0,9.999,7,0,[1,5],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orbitLight];
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.2,0.5,[1,1,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight];
		if (_clockwise) then {_rotationAngle = _rotationAngle + 1} else {_rotationAngle = _rotationAngle - 1};
		_arcSteps = _arcSteps - 1;
		uiSleep _orbitSpeed;
	};
	_jumpCount = _jumpCount - 1;
};
playSound3D ["lansare", objNull, false, [getMarkerPos _ufoMarker#0, getMarkerPos _ufoMarker#1, 200], 10, 1, 3000];
for "_i" from 1 to 10 do { 
	uiSleep 0.2;
	drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orbitLight];
};
drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orbitLight];
deleteVehicle _orbitLight;
deleteVehicle _orbitMarker;
