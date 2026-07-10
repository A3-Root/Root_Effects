#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side sensory pulse of one EMP detonation: a white flash, electric
 * static, then flickering chromatic distortion and film grain for players
 * inside the radius while the interference lasts. Everything is local and
 * cleans itself up.
 *
 * Arguments:
 * 0: Pulse center position ATL <ARRAY>
 * 1: Pulse radius in meters <NUMBER>
 * 2: Interference duration in seconds <NUMBER>
 * 3: Distort the HUD <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 300, 20, true] call root_effects_emp_fnc_empLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 300, [0]], ["_duration", 20, [0]], ["_hud", true, [false]]];

if (!hasInterface) exitWith {};
if ((player distance2D _pos) > (_radius * 2 max 1000)) exitWith {};

// Flash visible even from outside the radius.
private _flash = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 30]);
_flash setLightBrightness 60;
_flash setLightColor [0.7, 0.85, 1];
_flash setLightAmbient [0.7, 0.85, 1];
_flash setLightDayLight true;
_flash setLightUseFlare true;
_flash setLightFlareSize 60;
_flash setLightFlareMaxDistance 5000;

[{
    params ["_flash"];
    deleteVehicle _flash;
}, [_flash], 0.4] call CBA_fnc_waitAndExecute;

playSound3D ["A3\Sounds_F\sfx\SpottedNoise.wss", objNull, false, ATLToASL _pos, 5, 0.6, _radius * 2];

if (!_hud || {(player distance2D _pos) > _radius}) exitWith {};

// Flickering interference while the pulse lasts.
private _aberration = ppEffectCreate ["ChromAberration", 210];
_aberration ppEffectEnable true;

private _grain = ppEffectCreate ["FilmGrain", 2010];
_grain ppEffectEnable true;

// [aberration, grain, endTime]
[{
    params ["_args", "_handle"];
    _args params ["_aberration", "_grain", "_endTime"];

    if (CBA_missionTime >= _endTime) exitWith {
        ppEffectDestroy _aberration;
        ppEffectDestroy _grain;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _strength = linearConversion [_endTime - 20, _endTime, CBA_missionTime, 1, 0.1, true];
    private _jolt = _strength * (0.01 + random 0.05);
    _aberration ppEffectAdjust [_jolt, _jolt, true];
    _aberration ppEffectCommit 0.1;

    _grain ppEffectAdjust [_strength * (0.1 + random 0.3), 1, 1, 0, 1, false];
    _grain ppEffectCommit 0.1;
}, 0.15, [_aberration, _grain, CBA_missionTime + _duration]] call CBA_fnc_addPerFrameHandler;
