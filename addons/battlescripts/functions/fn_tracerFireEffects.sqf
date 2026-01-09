#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 



if (!hasInterface) exitWith {};

params ["_tracerObject", "_colorRed", "_colorGreen", "_colorBlue", "_activationDistance"];

private ["_xVelocity", "_yVelocity", "_zVelocity", "_tracerLight", "_lightRange", "_red", "_green", "_blue", "_tracerLifetime"];

_tracerLifetime = 3 + floor (random 10);

_red = _colorRed;
_green = _colorGreen;
_blue = _colorBlue;

_lightRange = 2;

while {tracerFireActive} do 
{
	if ((player distance _tracerObject) > _activationDistance) then {
		private _tracerCount = 2 + floor (random 8);
		_xVelocity = (floor (random 60)) * (selectRandom [1,-1]);
		_yVelocity = (floor (random 60)) * (selectRandom [1,-1]);
		_zVelocity = 70 + floor(random 100);	

		while {_tracerCount > 0} do {
			_tracerCount = _tracerCount - 1;
			private _tracerProjectile = createVehicle ["Land_Battery_F", getPosATL _tracerObject, [], 0, "CAN_COLLIDE"];
			_tracerProjectile setVelocity [_xVelocity + (random 1.5), _yVelocity + (random 1.5), _zVelocity + (random 1.5)];
			
			_tracerLight = "#lightpoint" createVehicleLocal (getPos _tracerProjectile);
			_tracerLight setLightAmbient[_red, _green, _blue];
			_tracerLight setLightColor[_red, _green, _blue];
			_tracerLight lightAttachObject [_tracerProjectile, [0,0,0]];
			_tracerLight setLightDayLight true;	
			_tracerLight setLightUseFlare true;
			_tracerLight setLightFlareSize 3;
			_tracerLight setLightFlareMaxDistance 5000;	
			_tracerLight setLightIntensity 5000;
			_tracerLight setLightAttenuation [_lightRange,0,100,0,_lightRange,_lightRange]; 			

			uiSleep (0.2 + (random 1));
			[_tracerProjectile, _tracerLifetime, _tracerLight] spawn {
				private _tracerProjectile = _this select 0;
				private _tracerLifetime = _this select 1;
				private _tracerLight = _this select 2;
				uiSleep _tracerLifetime;
				deleteVehicle _tracerProjectile;
				deleteVehicle _tracerLight;
			};			
		};
	};
	uiSleep (1 + (random 3));	
	if (!tracerSoundPlayed) then {
		[_tracerObject, ["ground_air", 2000]] remoteExec ["say3D"];
		tracerSoundPlayed = true;
		publicVariable "tracerSoundPlayed";
	};
};
