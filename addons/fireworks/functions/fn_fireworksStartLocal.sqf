#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side launcher loop for one fireworks display: at a jittered rate it
 * shoots a local rocket (glowing trail light rising from the launch site)
 * and schedules its burst at altitude. Skips launches while the player is
 * too far away and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Launches per minute <NUMBER>
 * 2: Launch area radius in meters <NUMBER>
 * 3: Detonation height in meters <NUMBER>
 * 4: Play launch and burst sounds <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 12, 50, 150, true] call root_effects_fireworks_fnc_fireworksStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_rate", 12, [0]], ["_radius", 50, [0]], ["_height", 150, [0]], ["_sounds", true, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, radius, height, sounds, baseInterval, nextLaunchTime]
private _state = [_anchor, _radius, _height, _sounds, 60 / (_rate max 1), 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_height", "_sounds", "_baseInterval", "_nextLaunch"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    if (CBA_missionTime < _nextLaunch) exitWith {};
    _args set [5, CBA_missionTime + _baseInterval * (0.6 + random 0.8)];

    if ((player distance2D _anchor) > EGVAR(main,maxViewDistance)) exitWith {};

    private _launchPos = _anchor getPos [random _radius, random 360];
    private _burstPos = _launchPos vectorAdd [random 20 - 10, random 20 - 10, _height * (0.8 + random 0.4)];
    private _flightTime = 1.8 + random 0.8;
    // Two-tone shells: the stars burn from the first colour into the second,
    // which reads far richer than a single flat hue.
    private _colors = selectRandom [
        [[1, 0.15, 0.1], [1, 0.8, 0.25]],
        [[0.2, 0.45, 1], [0.7, 0.9, 1]],
        [[0.2, 1, 0.3], [0.75, 1, 0.3]],
        [[1, 0.2, 0.9], [0.6, 0.3, 1]],
        [[1, 0.85, 0.3], [1, 1, 1]]
    ];

    if (_sounds && {(player distance2D _launchPos) < 1200}) then {
        playSound3D [selectRandom [
            "A3\Sounds_F\arsenal\weapons\Launchers\Titan\Titan.wss",
            "A3\Sounds_F\arsenal\weapons\Launchers\NLAW\nlaw.wss",
            "A3\Sounds_F\arsenal\weapons\Launchers\RPG32\rpg32.wss"
        ], objNull, false, ATLToASL _launchPos, 2, 1, 1200];
    };

    // Rising trail: a light climbing from the pad to the burst point, with a
    // spark trail attached so the shell leaves a wake on the way up.
    private _rocketLight = "#lightpoint" createVehicleLocal _launchPos;
    _rocketLight setLightBrightness 1.2;
    _rocketLight setLightColor [1, 0.75, 0.4];
    _rocketLight setLightAmbient [1, 0.75, 0.4];
    _rocketLight setLightUseFlare true;
    _rocketLight setLightFlareSize 6;
    _rocketLight setLightFlareMaxDistance 3000;

    private _trail = "#particlesource" createVehicleLocal _launchPos;
    _trail setParticleCircle [0, [0, 0, 0]];
    _trail setParticleRandom [0.3, [0.2, 0.2, 0.2], [1, 1, 1], 0, 0.05, [0, 0, 0, 0.3], 0, 0];
    _trail setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.9, [0, 0, 0], [0, 0, -1], 0, 1.2, 1, 0.05, [0.25, 0.05], [[1, 0.9, 0.5, 1], [1, 0.5, 0.15, 0.6], [0.8, 0.3, 0.05, 0]], [0.1, 0.4], 0, 0, "", "", _rocketLight];
    _trail setDropInterval (0.01 / ((EGVAR(main,particleBudget)) max 0.1));

    private _climb = (_burstPos vectorDiff _launchPos) vectorMultiply (1 / (_flightTime * 10));
    [{
        params ["_climbArgs", "_climbHandle"];
        _climbArgs params ["_rocketLight", "_climb", "_stepsLeft", "_trail"];

        if (_stepsLeft <= 0 || {isNull _rocketLight}) exitWith {
            deleteVehicle _rocketLight;
            deleteVehicle _trail;
            _climbHandle call CBA_fnc_removePerFrameHandler;
        };

        _rocketLight setPosATL ((getPosATL _rocketLight) vectorAdd _climb);
        _climbArgs set [2, _stepsLeft - 1];
    }, 0.1, [_rocketLight, _climb, ceil (_flightTime * 10), _trail]] call CBA_fnc_addPerFrameHandler;

    [FUNC(fireworkBurstLocal), [_burstPos, _colors, _sounds], _flightTime] call CBA_fnc_waitAndExecute;
}, 0.25, _state] call CBA_fnc_addPerFrameHandler;
