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

private _sounds = [QPATHTOF(sounds\explosion_1.ogg), QPATHTOF(sounds\explosion_2.ogg), QPATHTOF(sounds\explosion_3.ogg), QPATHTOF(sounds\explosion_4.ogg)];
private _soundPath = selectRandom _sounds;
playSound3D [_soundPath, objNull, false, ATLToASL _impactPos, 5, 1, 3000];

// A second, deeper report just behind the first gives the impact weight
// instead of a single flat crack.
[{
    params ["_impactPos", "_tailPath"];
    playSound3D [_tailPath, objNull, false, ATLToASL _impactPos, 4, 0.6, 3000];
}, [_impactPos, selectRandom (_sounds - [_soundPath])], 0.25] call CBA_fnc_waitAndExecute;

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

private _budget = (EGVAR(main,particleBudget)) max 0.1;

// Low dust pancake thrown outwards by the blast, gone within a second.
private _dust = "#particlesource" createVehicleLocal _impactPos;
_dust setParticleCircle [3, [6, 6, 0]];
_dust setParticleRandom [0.4, [1, 1, 0.2], [3, 3, 1], 0, 0.3, [0, 0, 0, 0.1], 0, 0];
_dust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 2.5, [0, 0, 0.2], [0, 0, 0.5], 0, 10, 7.5, 0.05, [4, 14], [[0.45, 0.4, 0.32, 0.7], [0.5, 0.46, 0.38, 0.35], [0.55, 0.5, 0.42, 0]], [0.6, 1], 1, 0, "", "", _impactPos];
_dust setDropInterval (0.01 / _budget);

// Slow dark plume rising out of the crater once the dust settles.
private _plume = "#particlesource" createVehicleLocal _impactPos;
_plume setParticleCircle [1, [0.5, 0.5, 0]];
_plume setParticleRandom [2, [1.5, 1.5, 0.5], [0.6, 0.6, 0.5], 0, 0.4, [0, 0, 0, 0.08], 0, 0];
_plume setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 5, [0, 0, 1], [0, 0, 1.5], 0, 10, 7.5, 0.02, [2, 8, 16], [[0.18, 0.18, 0.18, 0.6], [0.25, 0.25, 0.25, 0.3], [0.35, 0.35, 0.35, 0]], [0.5, 1], 1, 0, "", "", _impactPos];
_plume setDropInterval (0.06 / _budget);

[{
    params ["_flash"];
    deleteVehicle _flash;
}, [_flash], 0.3] call CBA_fnc_waitAndExecute;

[{
    params ["_dust"];
    deleteVehicle _dust;
}, [_dust], 0.5] call CBA_fnc_waitAndExecute;

[{
    params ["_plume"];
    deleteVehicle _plume;
}, [_plume], 1] call CBA_fnc_waitAndExecute;
