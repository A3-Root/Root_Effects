#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Renders one non-lethal artillery impact on this client: explosion sound
 * with distance based camera shake and, unless running in sound-only mode, a
 * short flash light and smoke plume at the impact point. Everything is local
 * and cleans itself up after a few seconds.
 *
 * Arguments:
 * 0: Impact position <ARRAY>
 * 1: Sound and shake only <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], false] call root_effects_battlescripts_fnc_artilleryImpactLocal
 */

params [["_impactPos", [0, 0, 0], [[]], 3], ["_soundOnly", false, [false]]];

if (!hasInterface) exitWith {};

private _distance = player distance2D _impactPos;
if (_distance > EGVAR(main,maxViewDistance)) exitWith {};

private _soundPath = selectRandom [QPATHTOF(sounds\explosion_1.ogg), QPATHTOF(sounds\explosion_2.ogg), QPATHTOF(sounds\explosion_3.ogg), QPATHTOF(sounds\explosion_4.ogg)];
playSound3D [_soundPath, objNull, false, ATLToASL _impactPos, 5, 1, 2000];

if (_distance < 500) then {
    addCamShake [5 * (1 - _distance / 500), 2, 25];
};

if (_soundOnly) exitWith {};

private _flash = "#lightpoint" createVehicleLocal (_impactPos vectorAdd [0, 0, 2]);
_flash setLightBrightness 10;
_flash setLightAmbient [1, 0.6, 0.4];
_flash setLightColor [1, 0.6, 0.4];
_flash setLightIntensity 10000;
_flash setLightAttenuation [0, 0, 0, 2.2, 500, 1000];

private _smoke = "#particlesource" createVehicleLocal _impactPos;
_smoke setParticleClass "GrenadeSmoke1";
_smoke setDropInterval (0.08 / ((EGVAR(main,particleBudget)) max 0.1));

[{
    params ["_flash"];
    deleteVehicle _flash;
}, [_flash], 0.3] call CBA_fnc_waitAndExecute;

[{
    params ["_smoke"];
    deleteVehicle _smoke;
}, [_smoke], 5] call CBA_fnc_waitAndExecute;
