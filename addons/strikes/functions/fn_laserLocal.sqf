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
 * 3: Beam color index: 0 red, 1 green, 2 blue <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 5, 3, 0] call root_effects_strikes_fnc_laserLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_chargeTime", 5, [0]], ["_beamTime", 3, [0]], ["_colorIndex", 0, [0]]];

if (!hasInterface) exitWith {};
if ((player distance2D _pos) > EGVAR(main,maxViewDistance)) exitWith {};

private _color = [[1, 0.2, 0.2], [0.2, 1, 0.2], [0.3, 0.5, 1]] param [_colorIndex, [1, 0.2, 0.2]];

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

    private _beamLights = [];
    for "_i" from 0 to 9 do {
        private _beamLight = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 5 + _i * 80]);
        _beamLight setLightBrightness 8;
        _beamLight setLightColor _color;
        _beamLight setLightAmbient _color;
        _beamLight setLightUseFlare true;
        _beamLight setLightFlareSize 20;
        _beamLight setLightFlareMaxDistance 6000;
        _beamLights pushBack _beamLight;
    };

    private _beamCore = "#particlesource" createVehicleLocal (_pos vectorAdd [0, 0, 2]);
    _beamCore setParticleCircle [0, [0, 0, 0]];
    _beamCore setParticleRandom [0, [1.5, 1.5, 400], [0, 0, 0], 0, 0.2, [0, 0, 0, 0], 0, 0];
    _beamCore setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.4, [0, 0, 400], [0, 0, 0], 0, 9.999, 7, 0, [4, 4], [(_color + [0.6]), (_color + [0])], [0.08], 0, 0, "", "", _pos];
    _beamCore setDropInterval (0.003 / ((EGVAR(main,particleBudget)) max 0.1));

    private _heatShimmer = "#particlesource" createVehicleLocal _pos;
    _heatShimmer setParticleCircle [3, [0, 0, 0]];
    _heatShimmer setParticleRandom [1, [2, 2, 5], [0, 0, 2], 0, 0.3, [0, 0, 0, 0], 0, 0];
    _heatShimmer setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 2], [0, 0, 5], 0, 9, 7, 0, [4, 8], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _pos];
    _heatShimmer setDropInterval 0.05;

    playSound3D ["A3\Sounds_F\arsenal\weapons_vehicles\cannon_120mm\Gatling_30mm_burst_02.wss", objNull, false, ATLToASL (_pos vectorAdd [0, 0, 50]), 3, 0.7, 3000];

    if ((player distance2D _pos) < 500) then {
        enableCamShake true;
        addCamShake [3, _beamTime, 20];
    };

    [{
        params ["_beamLights", "_beamCore", "_heatShimmer"];
        {
            deleteVehicle _x;
        } forEach _beamLights;
        deleteVehicle _beamCore;
        deleteVehicle _heatShimmer;
    }, [_beamLights, _beamCore, _heatShimmer], _beamTime] call CBA_fnc_waitAndExecute;
}, [_pos, _beamTime, _color], _chargeTime] call CBA_fnc_waitAndExecute;
