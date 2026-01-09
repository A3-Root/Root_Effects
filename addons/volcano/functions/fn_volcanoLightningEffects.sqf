#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 


if ((random 10) < 9.9) exitWith {};

private _lightningPos = _this;
private _lightningTexture = selectRandom ["A3\data_f\blesk1","A3\data_f\blesk2"];
private _thunderSound = selectRandom ["05_far","06_far","08_far","14_far","21_far","26_far"];

private _flashCount = floor (random 5);
drop [[_lightningTexture,1,0,1],"","SpaceObject",1,0.2,_lightningPos,[0,0,0],0,10,7.9,0,[3],[[1,1,1,1]],[1],0,0,"","",_lightningPos];
while {_flashCount > 0} do 
{
	private _lightningLight = "#lightpoint" createVehicle _lightningPos;
	_lightningLight setLightAttenuation [0,0,0,0,40,10000];
	private _brightness = 50 + (random 150);
	_lightningLight setLightBrightness _brightness;
	_lightningLight setLightDayLight true;	
	_lightningLight setLightUseFlare false;
	_lightningLight setLightFlareSize 50;
	_lightningLight setLightFlareMaxDistance 2000;	
	_lightningLight setLightAmbient[1,1,1];
	_lightningLight setLightColor[1,1,1];
	uiSleep (0.15 + (random 0.2));
	deleteVehicle _lightningLight;
	_flashCount = _flashCount - 1;
};
uiSleep 0.5;
playSound _thunderSound;
