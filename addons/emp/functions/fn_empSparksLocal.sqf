#include "..\script_component.hpp"

/*
 * Author: Root
 * Client spark burst on an object burning out, using the ambient sparks shower and
 * crackle. Blowout adds more bursts, a bright flash and a smoke puff.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Blowout <BOOL>
 * 2: Height of the burst as a fraction of the object height <NUMBER> (optional, default 0.9)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_lamp, true] call root_effects_emp_fnc_empSparksLocal
 */

params [["_object", objNull, [objNull]], ["_blowout", false, [false]], ["_height", 0.9, [0]]];

if (!hasInterface || {isNull _object}) exitWith {};
if ((_object distance (positionCameraToWorld [0, 0, 0])) > 400) exitWith {};

private _offset = [0, 0, ((boundingBoxReal _object) select 1 select 2) * _height];
[_object, [1, 2 + floor random 2] select _blowout, _offset, [0.4, 0.8] select _blowout] call EFUNC(ambientsfx,sparkBurstLocal);

if (!_blowout) exitWith {};

private _pos = _object modelToWorld _offset;
private _flash = "#lightpoint" createVehicleLocal _pos;
_flash setLightColor [1, 0.8, 0.5];
_flash setLightAmbient [1, 0.7, 0.4];
_flash setLightBrightness 4;
_flash setLightUseFlare true;
_flash setLightFlareSize 3;
_flash setLightFlareMaxDistance 800;
[{deleteVehicle (_this select 0)}, [_flash], 0.15] call CBA_fnc_waitAndExecute;
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 1.5, _pos, [0, 0, 0.5], 0, 1.275, 1, 0, [0.5, 2],
    [[0.2, 0.2, 0.2, 0.6], [0.3, 0.3, 0.3, 0]], [1], 0, 0, "", "", objNull];
