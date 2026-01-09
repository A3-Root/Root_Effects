#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

private _meteorObject = _this select 0;
private _startPos = getPos _meteorObject;
private _flashChance = random 30;
if (_flashChance < 7) then {
private _flashLight = "#lightpoint" createVehicleLocal getPos _meteorObject;
_flashLight setPos _startPos;
_flashLight setLightDayLight true;
_flashLight setLightBrightness 30000;
_flashLight setLightAmbient [0.5, 0.5, 1];
_flashLight setLightColor [1, 1, random 2];
uiSleep 0.5;
deleteVehicle _flashLight;
};
