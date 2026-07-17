#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side visuals for one orbital laser strike: a charging glow growing
 * at the target point, then a vertical column of lights and refraction
 * particles hammering down from the sky for the beam duration. Everything is
 * local and cleans itself up.
 *
 * Arguments:
 * 0: Target position ATL <ARRAY>
 * 1: Charge up time in seconds <NUMBER>
 * 2: Beam duration in seconds <NUMBER>
 * 3: Beam color as [r, g, b] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 5, 3, [1, 0.2, 0.2]] call root_effects_strikes_fnc_laserLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_chargeTime", 5, [0]], ["_beamTime", 3, [0]], ["_color", [1, 0.2, 0.2], [[]], 3]];

if (!hasInterface) exitWith {};
if ((player distance2D _pos) > EGVAR(main,maxViewDistance)) exitWith {};

// Charging glow that grows until the beam fires.
private _chargeLight = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 2]);
_chargeLight setLightBrightness 0.1;
_chargeLight setLightColor _color;
_chargeLight setLightAmbient _color;
_chargeLight setLightUseFlare true;
_chargeLight setLightFlareSize 2;
_chargeLight setLightFlareMaxDistance 4000;

playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", objNull, false, ATLToASL _pos, 2, 1.5, 1500];

private _chargeStep = 4 / (_chargeTime * 10);
[{
    params ["_args", "_handle"];
    _args params ["_chargeLight", "_chargeStep", "_brightness", "_stepsLeft"];

    if (_stepsLeft <= 0) exitWith {
        deleteVehicle _chargeLight;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    _brightness = _brightness + _chargeStep;
    _chargeLight setLightBrightness _brightness;
    _chargeLight setLightFlareSize (2 + _brightness * 4);
    _args set [2, _brightness];
    _args set [3, _stepsLeft - 1];
}, 0.1, [_chargeLight, _chargeStep, 0.1, ceil (_chargeTime * 10)]] call CBA_fnc_addPerFrameHandler;

// Beam column after the charge completes.
[{
    params ["_pos", "_beamTime", "_color"];

    // Closely spaced lights keep the column lit end to end; too few and too
    // bright reads as a string of separate lamps rather than a beam.
    private _beamLights = [];
    for "_i" from 0 to 13 do {
        private _beamLight = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 5 + _i * 55]);
        _beamLight setLightBrightness 4;
        _beamLight setLightColor _color;
        _beamLight setLightAmbient _color;
        _beamLight setLightUseFlare true;
        _beamLight setLightFlareSize 10;
        _beamLight setLightFlareMaxDistance 6000;
        _beamLights pushBack _beamLight;
    };

    private _budget = (EGVAR(main,particleBudget)) max 0.1;

    // The beam is built from two collimated columns: a coloured sheath and a
    // white core inside it. Particles are dense, small and barely spread
    // sideways, which is what makes the column read as solid light.
    private _beamCore = "#particlesource" createVehicleLocal (_pos vectorAdd [0, 0, 2]);
    _beamCore setParticleCircle [0, [0, 0, 0]];
    _beamCore setParticleRandom [0, [0.3, 0.3, 400], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 0, 0];
    _beamCore setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.35, [0, 0, 400], [0, 0, 0], 0, 9.999, 7, 0, [3, 3], [(_color + [0.9]), (_color + [0])], [0.08], 0, 0, "", "", _pos];
    _beamCore setDropInterval (0.0008 / _budget);

    private _beamInner = "#particlesource" createVehicleLocal (_pos vectorAdd [0, 0, 2]);
    _beamInner setParticleCircle [0, [0, 0, 0]];
    _beamInner setParticleRandom [0, [0.05, 0.05, 400], [0, 0, 0], 0, 0.05, [0, 0, 0, 0], 0, 0];
    _beamInner setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.35, [0, 0, 400], [0, 0, 0], 0, 9.999, 7, 0, [1.2, 1.2], [[1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 0, 0, "", "", _pos];
    _beamInner setDropInterval (0.0012 / _budget);

    // Haze runs the full height of the column, not just the base, so the air
    // around the whole beam boils rather than only the impact point.
    private _heatShimmer = "#particlesource" createVehicleLocal _pos;
    _heatShimmer setParticleCircle [3, [0, 0, 0]];
    _heatShimmer setParticleRandom [1, [2, 2, 400], [0, 0, 2], 0, 0.3, [0, 0, 0, 0], 0, 0];
    _heatShimmer setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 2], [0, 0, 5], 0, 9, 7, 0, [4, 8], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _pos];
    _heatShimmer setDropInterval 0.02;

    // The volumetric shaft only reads against a dark sky; in daylight it just
    // washes out, so it is skipped.
    private _shaft = objNull;
    if (sunOrMoon < 0.4) then {
        _shaft = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", ATLToASL _pos, true];
        _shaft setVectorDirAndUp [[0, 0, 1], [0, 1, 0]];
    };

    // Sound in layers: the crack of the beam striking, then a rolling echo off
    // the terrain a beat later.
    playSound3D ["A3\Sounds_F\arsenal\weapons_vehicles\cannon_120mm\Gatling_30mm_burst_02.wss", objNull, false, ATLToASL (_pos vectorAdd [0, 0, 50]), 3, 0.7, 3000];
    [{
        params ["_pos"];
        playSound3D ["A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_04.wss", objNull, false, ATLToASL _pos, 4, 0.45, 4000];
    }, [_pos], 0.5] call CBA_fnc_waitAndExecute;

    private _distance = player distance2D _pos;
    if (_distance < 500) then {
        // Shake in stages across the burn: the hit, then a settling rumble.
        enableCamShake true;
        addCamShake [6 * (1 - _distance / 500), 1, 25];
        [{
            params ["_beamTime", "_power"];
            addCamShake [_power, _beamTime, 15];
        }, [_beamTime, 3 * (1 - _distance / 500)], 1] call CBA_fnc_waitAndExecute;
    };

    // Anyone looking at the strike from close by gets flash blinded.
    if (_distance < 800) then {
        private _toBeam = vectorNormalized ((ATLToASL _pos) vectorDiff (positionCameraToWorld [0, 0, 0]));
        private _facing = _toBeam vectorDotProduct (vectorNormalized ((positionCameraToWorld [0, 0, 1]) vectorDiff (positionCameraToWorld [0, 0, 0])));

        if (_facing > 0.4) then {
            private _strength = linearConversion [0, 800, _distance, 1, 0.15, true] * _facing;

            private _flashLayer = ppEffectCreate ["ColorCorrections", 2400];
            _flashLayer ppEffectEnable true;
            _flashLayer ppEffectAdjust [1, 1, 0, [1, 1, 1, _strength], [1, 1, 1, 0], [1, 1, 1, 0]];
            _flashLayer ppEffectCommit 0.1;

            private _blurLayer = ppEffectCreate ["DynamicBlur", 2401];
            _blurLayer ppEffectEnable true;
            _blurLayer ppEffectAdjust [4 * _strength];
            _blurLayer ppEffectCommit 0.1;

            [{
                params ["_flashLayer", "_blurLayer"];
                _flashLayer ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 0], [1, 1, 1, 0]];
                _flashLayer ppEffectCommit 1.5;
                _blurLayer ppEffectAdjust [0];
                _blurLayer ppEffectCommit 1.5;

                [{
                    params ["_flashLayer", "_blurLayer"];
                    ppEffectDestroy _flashLayer;
                    ppEffectDestroy _blurLayer;
                }, [_flashLayer, _blurLayer], 2] call CBA_fnc_waitAndExecute;
            }, [_flashLayer, _blurLayer], 0.4] call CBA_fnc_waitAndExecute;
        };
    };

    // Aftermath left behind where the beam bit into the ground.
    private _scorch = "Crater" createVehicleLocal _pos;
    _scorch setPosATL _pos;

    private _impactDust = "#particlesource" createVehicleLocal _pos;
    _impactDust setParticleCircle [2, [4, 4, 0]];
    _impactDust setParticleRandom [1, [2, 2, 0.5], [2, 2, 1.5], 0, 0.3, [0, 0, 0, 0.1], 0, 0];
    _impactDust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 4, [0, 0, 0.5], [0, 0, 1.2], 0, 10, 7.5, 0.05, [2, 8], [(_color + [0.5]), (_color + [0.25]), [0.4, 0.4, 0.4, 0]], [0.4, 1], 1, 0, "", "", _pos];
    _impactDust setDropInterval (0.03 / _budget);

    [{
        params ["_impactDust"];
        deleteVehicle _impactDust;
    }, [_impactDust], _beamTime + 3] call CBA_fnc_waitAndExecute;

    [{
        params ["_beamLights", "_beamCore", "_beamInner", "_heatShimmer", "_shaft"];
        {
            deleteVehicle _x;
        } forEach _beamLights;
        deleteVehicle _beamCore;
        deleteVehicle _beamInner;
        deleteVehicle _heatShimmer;
        deleteVehicle _shaft;
    }, [_beamLights, _beamCore, _beamInner, _heatShimmer, _shaft], _beamTime] call CBA_fnc_waitAndExecute;
}, [_pos, _beamTime, _color], _chargeTime] call CBA_fnc_waitAndExecute;
