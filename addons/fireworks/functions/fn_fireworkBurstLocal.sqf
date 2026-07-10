#include "..\script_component.hpp"

/*
 * Author: Root
 * Detonates one firework on this client: a bright colored flash light that
 * fades over the fall time and a glitter shell of colored star particles
 * spreading from the burst point, with an optional delayed report sound.
 * Everything is local and cleans itself up.
 *
 * Arguments:
 * 0: Burst position ATL <ARRAY>
 * 1: Burst color as [r, g, b] <ARRAY>
 * 2: Play the burst report <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 150], [1, 0.3, 0.2], true] call root_effects_fireworks_fnc_fireworkBurstLocal
 */

params [["_burstPos", [0, 0, 0], [[]], 3], ["_color", [1, 1, 1], [[]], 3], ["_sounds", true, [false]]];

if (!hasInterface) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;

// Burst flash.
private _flash = "#lightpoint" createVehicleLocal _burstPos;
_flash setLightBrightness 6;
_flash setLightColor _color;
_flash setLightAmbient _color;
_flash setLightUseFlare true;
_flash setLightFlareSize 12;
_flash setLightFlareMaxDistance 4000;

// Glitter shell of falling stars.
private _stars = "#particlesource" createVehicleLocal _burstPos;
_stars setParticleCircle [0, [0, 0, 0]];
_stars setParticleRandom [0.6, [1, 1, 1], [22, 22, 22], 0, 0.4, [0, 0, 0, 0], 0, 0];
_stars setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 2.4, [0, 0, 0], [0, 0, -4], 0, 1.2, 1, 0.1, [1.6, 1.2, 0.4], [(_color + [1]), (_color + [0.7]), (_color + [0])], [0.08], 0, 0, "", "", _burstPos];
_stars setDropInterval (0.004 / _budget);

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

// Fade the flash while the stars fall, then clean up.
[{
    params ["_fadeArgs", "_fadeHandle"];
    _fadeArgs params ["_flash", "_stars", "_brightness"];

    _brightness = _brightness - 0.5;
    _fadeArgs set [2, _brightness];

    if (_brightness <= 0) exitWith {
        deleteVehicle _flash;
        [{
            params ["_stars"];
            deleteVehicle _stars;
        }, [_stars], 1] call CBA_fnc_waitAndExecute;
        _fadeHandle call CBA_fnc_removePerFrameHandler;
    };

    _flash setLightBrightness _brightness;
    _flash setLightFlareSize (_brightness * 2);
}, 0.15, [_flash, _stars, 6]] call CBA_fnc_addPerFrameHandler;
