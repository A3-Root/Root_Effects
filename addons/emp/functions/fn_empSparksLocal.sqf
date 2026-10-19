#include "..\script_component.hpp"

/*
 * Author: Root
 * Client spark burst on an object burning out: a shower of sparks with crackle.
 * Blowout adds a short flicker of light, a pop and a bigger shower.
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

private _viewer = positionCameraToWorld [0, 0, 0];
if ((_object distance _viewer) > 400) exitWith {};

private _pos = _object modelToWorld [0, 0, ((boundingBoxReal _object) select 1 select 2) * _height];
private _budget = (EGVAR(main,particleBudget)) max 0.1;
private _count = ceil (([10, 30] select _blowout) * _budget);
private _speed = [2, 6] select _blowout;

for "_i" from 1 to _count do {
    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.5 + random 0.8, _pos, [random (2 * _speed) - _speed, random (2 * _speed) - _speed, random _speed], 0, 4, 1, 0.1, [0.12, 0.03],
        [[1, 0.9, 0.6, 1], [1, 0.6, 0.2, 0]], [1], 0, 0, "", "", objNull];
};
playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", objNull, false, AGLToASL _pos, [1.5, 3] select _blowout, 0.9 + random 0.4, [80, 200] select _blowout];

if (!_blowout) exitWith {};

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
