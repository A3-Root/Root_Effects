// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!hasInterface) exitWith {};

private _falling_meteor_ini = _this select 0;
private _poz_ini = getPos _falling_meteor_ini;
private _blinding = random 30;
if (_blinding < 7) then {
private _light = "#lightpoint" createVehicleLocal getPos _falling_meteor_ini;
_light setPos _poz_ini;
_light setLightDayLight true;
_light setLightBrightness 30000;
_light setLightAmbient [0.5, 0.5, 1];
_light setLightColor [1, 1, random 2];
uiSleep 0.5;
deleteVehicle _light;
};
