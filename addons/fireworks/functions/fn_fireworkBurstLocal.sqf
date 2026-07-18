#include "..\script_component.hpp"

/*
 * Author: Root
 * Detonates one firework on this client: a hard flash, a spherical shell of
 * stars fading from the shell's primary colour into its secondary, a glitter
 * layer, a spray of burning flare-object stars that arc out on smoke trails
 * with their own coloured lights and, now and then, small secondary pops a
 * moment later. Everything is local and cleans itself up.
 *
 * Arguments:
 * 0: Burst position ATL <ARRAY>
 * 1: Shell colours [primary, secondary], each [r, g, b] <ARRAY>
 * 2: Play the burst report <BOOL>
 * 3: Scale of the burst, 1 for a full shell <NUMBER> (default: 1)
 * 4: Allow secondary pops <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 150], [[1, 0.2, 0.15], [1, 0.8, 0.3]], true] call root_effects_fireworks_fnc_fireworkBurstLocal
 */

params [["_burstPos", [0, 0, 0], [[]], 3], ["_colors", [[1, 1, 1], [1, 1, 1]], [[]], 2], ["_sounds", true, [false]], ["_scale", 1, [0]], ["_allowSub", true, [false]]];

if (!hasInterface) exitWith {};

_colors params [["_primary", [1, 1, 1], [[]], 3], ["_secondary", [1, 1, 1], [[]], 3]];

private _budget = (EGVAR(main,particleBudget)) max 0.1;

// Burst flash.
private _flash = "#lightpoint" createVehicleLocal _burstPos;
_flash setLightBrightness 10 * _scale;
_flash setLightColor _primary;
_flash setLightAmbient _primary;
_flash setLightUseFlare true;
_flash setLightFlareSize 20 * _scale;
_flash setLightFlareMaxDistance 4000;

// Main shell: stars thrown evenly in every direction, burning from the shell's
// primary colour through its secondary before they die.
private _stars = "#particlesource" createVehicleLocal _burstPos;
_stars setParticleCircle [0, [0, 0, 0]];
_stars setParticleRandom [0.4, [0.5, 0.5, 0.5], [26 * _scale, 26 * _scale, 26 * _scale], 0, 0.1, [0, 0, 0, 0], 0, 0];
_stars setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 3.2, [0, 0, 0], [0, 0, 0], 0, 1.15, 1, 0.06, [0.3 * _scale], [(_primary + [1]), (_secondary + [0.85]), (_secondary + [0])], [0.1, 0.4, 0.7], 0, 0, "", "", _burstPos];
_stars setDropInterval (0.0015 / _budget);

// Glitter riding inside the shell, finer and longer lived than the stars.
private _glitter = "#particlesource" createVehicleLocal _burstPos;
_glitter setParticleCircle [0, [0, 0, 0]];
_glitter setParticleRandom [0.8, [0.3, 0.3, 0.3], [18 * _scale, 18 * _scale, 18 * _scale], 0, 0.05, [0, 0, 0, 0.5], 0, 0];
_glitter setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 4.5, [0, 0, 0], [0, 0, 0], 0, 1.1, 1, 0.05, [0.12 * _scale], [[1, 1, 0.95, 1], [1, 0.9, 0.5, 0.6], [1, 0.85, 0.4, 1], [1, 1, 1, 0]], [0.05, 0.2, 0.5, 0.8], 0, 0, "", "", _burstPos];
_glitter setDropInterval (0.004 / _budget);

// Burning flare stars: real objects flung out on their own ballistic arcs,
// each trailing smoke and self-illuminating, so the shell leaves live streaking
// trails. The flares carry the burst's light themselves, so no extra dynamic
// lights are attached, and the count scales with the particle budget to keep
// the object and light load down when the sky is busy.
private _flareCount = (round (9 * _scale * _budget)) max 4;
private _flares = [];
for "_i" from 1 to _flareCount do {
    private _star = "CMflare_Chaff_ammo" createVehicleLocal _burstPos;
    _star setPosATL _burstPos;

    // Spread the stars over a sphere biased slightly upward, then let gravity
    // pull each arc back down.
    private _dir = vectorNormalized [random 2 - 1, random 2 - 1, (random 2 - 1) * 0.7 + 0.25];
    _star setVelocity (_dir vectorMultiply ((14 + random 12) * _scale));

    _flares pushBack _star;
};

// Let the stars burn and arc, then clear them.
[{
    params ["_flares"];
    {
        deleteVehicle _x;
    } forEach _flares;
}, [_flares], 4 + random 1.5] call CBA_fnc_waitAndExecute;

if (_sounds && {(player distance2D _burstPos) < 2500}) then {
    // The report arrives after the light, delayed by distance.
    [{
        params ["_burstPos"];
        playSound3D [selectRandom [
            "A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01.wss",
            "A3\Sounds_F\arsenal\explosives\shells\tank_shell_explosion_02.wss",
            "A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_04.wss"
        ], objNull, false, ATLToASL _burstPos, 3, 1, 2500];
    }, [_burstPos], ((player distance2D _burstPos) / 343) min 2] call CBA_fnc_waitAndExecute;
};

// Some shells throw small secondary pops around the main burst. These never
// pop again themselves, so the chain always ends here. The chance and count are
// held down and scaled by the particle budget so a volley cannot cascade into a
// framerate sink.
if (_allowSub && {random 1 < 0.15 * _budget}) then {
    for "_i" from 1 to (1 + floor random 2) do {
        private _subPos = _burstPos vectorAdd [random 30 - 15, random 30 - 15, random 20 - 10];
        [FUNC(fireworkBurstLocal), [_subPos, [_secondary, _primary], false, _scale * 0.5, false], 0.3 + random 0.5] call CBA_fnc_waitAndExecute;
    };
};

// Fade the flash while the stars fall, then clean up.
[{
    params ["_fadeArgs", "_fadeHandle"];
    _fadeArgs params ["_flash", "_stars", "_glitter", "_brightness", "_scale"];

    _brightness = _brightness - 0.8;
    _fadeArgs set [3, _brightness];

    if (_brightness <= 0) exitWith {
        deleteVehicle _flash;
        [{
            params ["_stars", "_glitter"];
            deleteVehicle _stars;
            deleteVehicle _glitter;
        }, [_stars, _glitter], 1] call CBA_fnc_waitAndExecute;
        _fadeHandle call CBA_fnc_removePerFrameHandler;
    };

    _flash setLightBrightness _brightness;
    _flash setLightFlareSize (_brightness * 2 * _scale);
}, 0.15, [_flash, _stars, _glitter, 10 * _scale, _scale]] call CBA_fnc_addPerFrameHandler;
