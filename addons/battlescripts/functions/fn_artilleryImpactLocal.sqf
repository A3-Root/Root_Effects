#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Renders one non-lethal artillery impact on this client: a double explosion
 * report from its own sound source (so the next shell never cuts it off) with
 * distance based camera shake and, unless running in sound-only mode, a flak
 * style flash with lens flare, a fireball, sparks, flying earth, a dust ring, a
 * dark smoke column and smouldering crater smoke. Everything is local and cleans
 * itself up within a few seconds.
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

private _distance = VIEWER_POS distance2D _impactPos;
if (_distance > EGVAR(main,maxViewDistance)) exitWith {};
DBG(FORMAT_1("artilleryImpactLocal running here with %1",_this));

// Every impact gets its own sound source that lives until the reports have rung
// out. A shared source (or a sound that dies with its emitter) gets cut off by the
// next shell, which breaks the rolling rhythm of a barrage.
private _voice = "Land_HelipadEmpty_F" createVehicleLocal _impactPos;
_voice setPosATL (_impactPos vectorAdd [0, 0, 1]);
private _sounds = [QGVAR(explosion_1), QGVAR(explosion_2), QGVAR(explosion_3), QGVAR(explosion_4)];
private _report = selectRandom _sounds;
_voice say3D [_report, 3000];

// A second, deeper report just behind the first gives the impact weight.
private _tailVoice = "Land_HelipadEmpty_F" createVehicleLocal _impactPos;
_tailVoice setPosATL (_impactPos vectorAdd [0, 0, 1]);
[{
    params ["_tailVoice", "_tail"];
    if (!isNull _tailVoice) then {_tailVoice say3D [_tail, 3000, 0.6]};
}, [_tailVoice, selectRandom (_sounds - [_report])], 0.25] call CBA_fnc_waitAndExecute;

[{
    params ["_voice", "_tailVoice"];
    deleteVehicle _voice;
    deleteVehicle _tailVoice;
}, [_voice, _tailVoice], 15] call CBA_fnc_waitAndExecute;

if (_distance < 600) then {
    enableCamShake true;
    addCamShake [6 * (1 - _distance / 600), 2.5, 25];
};

if (_soundOnly) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;

// Flash: same treatment as the flak bursts, a daylight-visible light with a big
// lens flare that pops and then fades.
private _flash = "#lightpoint" createVehicleLocal (_impactPos vectorAdd [0, 0, 3]);
_flash setLightDayLight true;
_flash setLightUseFlare true;
_flash setLightFlareSize (30 + random 30);
_flash setLightFlareMaxDistance 5000;
_flash setLightAttenuation [0, 0, 0, 1.6, 600, 1200];
_flash setLightColor [1, 0.6, 0.3];
_flash setLightAmbient [1, 0.55, 0.3];
_flash setLightIntensity (3000 + random 2000);
[{
    params ["_args", "_handle"];
    _args params ["_flash", "_start"];
    private _age = CBA_missionTime - _start;
    if (isNull _flash || _age > 0.7) exitWith {
        deleteVehicle _flash;
        _handle call CBA_fnc_removePerFrameHandler;
    };
    // Hold briefly at full strength, then fade out.
    private _level = linearConversion [0.15, 0.7, _age, 1, 0, true];
    _flash setLightIntensity (4000 * _level);
    _flash setLightFlareSize (45 * _level);
}, 0, [_flash, CBA_missionTime]] call CBA_fnc_addPerFrameHandler;

// Fireball: a short burst of glowing flame rolling up out of the crater.
private _fire = "#particlesource" createVehicleLocal _impactPos;
_fire setParticleCircle [1, [3, 3, 0]];
_fire setParticleRandom [0.2, [1.5, 1.5, 0.5], [4, 4, 4], 0, 0.4, [0, 0, 0, 0], 0, 0];
_fire setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 10, 32], "", "Billboard", 1, 0.8, [0, 0, 1], [0, 0, 6], 0, 10, 7.9, 0.1, [4, 9, 12], [[1, 0.8, 0.5, 0.9], [1, 0.45, 0.15, 0.6], [0.3, 0.15, 0.1, 0]], [1], 1, 0, "", "", _impactPos, 0, false, 0, [[30, 18, 8, 1], [12, 5, 1, 0.5], [0, 0, 0, 0]]];
_fire setDropInterval (0.01 / _budget);

// Sparks and embers thrown out of the blast.
private _sparks = "#particlesource" createVehicleLocal _impactPos;
_sparks setParticleCircle [0.5, [0, 0, 0]];
_sparks setParticleRandom [0.4, [0.5, 0.5, 0.3], [14, 14, 12], 0, 0.05, [0, 0, 0, 0], 0, 0];
_sparks setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 1.2, [0, 0, 1], [0, 0, 14], 0, 25, 7.9, 0.08, [0.25, 0.15], [[1, 0.7, 0.3, 1], [1, 0.4, 0.1, 0]], [1], 1, 0, "", "", _impactPos, 0, true, 0.3, [[60, 30, 10, 1], [0, 0, 0, 0]]];
_sparks setDropInterval (0.004 / _budget);

// Clods of earth and stone on ballistic arcs.
private _debris = "#particlesource" createVehicleLocal _impactPos;
_debris setParticleCircle [1, [0, 0, 0]];
_debris setParticleRandom [0.5, [1, 1, 0.5], [10, 10, 8], 0, 0.5, [0, 0, 0, 0], 1, 0];
_debris setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 3, [0, 0, 1], [0, 0, 18], 1, 200, 6, 0, [1, 1.2], [[0.3, 0.26, 0.2, 1], [0.3, 0.26, 0.2, 1]], [1], 1, 0, "", "", _impactPos, 0, true, 0.4];
_debris setDropInterval (0.01 / _budget);

// Dust ring blasted outwards along the ground.
private _dust = "#particlesource" createVehicleLocal _impactPos;
_dust setParticleCircle [4, [12, 12, 0]];
_dust setParticleRandom [0.6, [2, 2, 0.3], [5, 5, 1], 0, 0.4, [0, 0, 0, 0.1], 0, 0];
_dust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 9, 0], "", "Billboard", 1, 4, [0, 0, 0.3], [0, 0, 0.6], 0, 10, 7.5, 0.06, [10, 22, 30], [[0.45, 0.4, 0.32, 0.75], [0.5, 0.46, 0.38, 0.4], [0.55, 0.5, 0.42, 0]], [0.6, 1], 1, 0, "", "", _impactPos];
_dust setDropInterval (0.006 / _budget);

// Thick dark column climbing out of the crater and drifting off.
private _column = "#particlesource" createVehicleLocal _impactPos;
_column setParticleCircle [1.5, [0.5, 0.5, 0]];
_column setParticleRandom [4, [2, 2, 1], [1, 1, 1], 0, 0.5, [0, 0, 0, 0.08], 0, 0];
_column setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 7, 48], "", "Billboard", 1, 16, [0, 0, 2], [0, 0, 4], 0, 10, 7.6, 0.03, [4, 14, 25], [[0.1, 0.1, 0.1, 0.85], [0.18, 0.18, 0.18, 0.5], [0.3, 0.3, 0.3, 0]], [0.4, 0.8], 1, 0.3, "", "", _impactPos];
_column setDropInterval (0.04 / _budget);

// Low smoke left smouldering over the crater.
private _smoulder = "#particlesource" createVehicleLocal _impactPos;
_smoulder setParticleCircle [2, [0.3, 0.3, 0]];
_smoulder setParticleRandom [2, [2, 2, 0.3], [0.5, 0.5, 0.3], 0, 0.3, [0, 0, 0, 0.05], 0, 0];
_smoulder setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 7, 48], "", "Billboard", 1, 7, [0, 0, 0.5], [0, 0, 0.6], 0, 10, 7.85, 0.02, [3, 8, 12], [[0.2, 0.2, 0.2, 0.5], [0.25, 0.25, 0.25, 0.3], [0.3, 0.3, 0.3, 0]], [0.5], 1, 0.2, "", "", _impactPos];
_smoulder setDropInterval (0.12 / _budget);

[{
    params ["_fire", "_sparks", "_debris"];
    deleteVehicle _fire;
    deleteVehicle _sparks;
    deleteVehicle _debris;
}, [_fire, _sparks, _debris], 0.35] call CBA_fnc_waitAndExecute;

[{
    params ["_dust"];
    deleteVehicle _dust;
}, [_dust], 0.8] call CBA_fnc_waitAndExecute;

[{
    params ["_column"];
    deleteVehicle _column;
}, [_column], 2.5] call CBA_fnc_waitAndExecute;

[{
    params ["_smoulder"];
    deleteVehicle _smoulder;
}, [_smoulder], 6] call CBA_fnc_waitAndExecute;
