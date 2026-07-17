#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side visuals for one scree avalanche: boulders and stones tumbling
 * down the slope inside a rolling dust cloud, with rockfall cracks from a
 * sound source that moves with the front and a rumble underfoot. All local,
 * cleans itself up in stages and skips machines out of view range.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Travel heading in degrees <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 90, 200, 25] call root_effects_volcano_fnc_avalancheLocal
 */

params [["_anchor", objNull, [objNull]], ["_heading", 0, [0]], ["_length", 200, [0]], ["_duration", 25, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};
if ((player distance2D _anchor) > ((EGVAR(main,maxViewDistance)) max 2000)) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;
private _pos = getPosATL _anchor;

// Everything travels along the slide direction at the speed needed to cover
// the corridor in the configured time.
private _speed = _length / _duration;
private _flow = [sin _heading * _speed, cos _heading * _speed, -2];

private _dust = "#particlesource" createVehicleLocal _pos;
_dust setParticleCircle [12, [0, 0, 0]];
_dust setParticleRandom [6, [10, 10, 3], [4, 4, 2], 0, 0.5, [0, 0, 0, 0.1], 0, 0];
_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 16, [0, 0, 2], _flow vectorAdd [0, 0, 3], 0, 10, 7.5, 0.02, [6, 20, 35], [[0.42, 0.38, 0.32, 0.6], [0.48, 0.44, 0.38, 0.35], [0.52, 0.5, 0.45, 0]], [0.3, 0.8], 1, 0, "", "", _anchor];
_dust setDropInterval (0.02 / _budget);

// Boulders bouncing their way down inside the cloud.
private _boulders = "#particlesource" createVehicleLocal _pos;
_boulders setParticleCircle [8, [0, 0, 0]];
_boulders setParticleRandom [3, [8, 8, 2], [_speed / 2, _speed / 2, 4], 0, 0.4, [0, 0, 0, 0.2], 1, 0];
_boulders setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 1], _flow vectorAdd [0, 0, 6], 1, 300, 6, 0, [2.5, 2.5, 2], [[0.3, 0.28, 0.25, 1], [0.35, 0.33, 0.3, 1], [0.4, 0.38, 0.35, 1]], [0.5], 1, 0, "", "", _anchor, 0, true, 0.6, [[0, 0, 0, 0]]];
_boulders setDropInterval (0.06 / _budget);

private _stones = "#particlesource" createVehicleLocal _pos;
_stones setParticleCircle [10, [0, 0, 0]];
_stones setParticleRandom [3, [10, 10, 2], [_speed, _speed, 5], 0, 0.4, [0, 0, 0, 0.2], 1, 0];
_stones setParticleParams [["\A3\data_f\ParticleEffects\Universal\StoneSmall.p3d", 1, 0, 1], "", "SpaceObject", 1, 8, [0, 0, 1], _flow vectorAdd [0, 0, 4], 1, 200, 6, 0, [1, 1, 0.8], [[0.35, 0.33, 0.3, 1], [0.4, 0.38, 0.35, 1], [0.45, 0.43, 0.4, 1]], [0.5], 1, 0, "", "", _anchor, 0, true, 0.7, [[0, 0, 0, 0]]];
_stones setDropInterval (0.02 / _budget);

// Sound source riding the front so the noise travels with the rock.
private _soundSource = "Land_HelipadEmpty_F" createVehicleLocal _pos;

private _distance = player distance2D _pos;
if (_distance < _length * 3) then {
    private _falloff = linearConversion [0, _length * 3, _distance, 1, 0.1, true];
    enableCamShake true;
    addCamShake [4 * _falloff, _duration, 15];
};

playSound (selectRandom [QGVAR(earthquake_1), QGVAR(earthquake_2)]);

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_soundSource", "_heading", "_length", "_duration", "_startTime"];

    if (isNull _anchor) exitWith {
        deleteVehicle _soundSource;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _progress = (CBA_missionTime - _startTime) / _duration;
    if (_progress > 1) exitWith {
        deleteVehicle _soundSource;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Track the front and crack off it from a slightly different spot each
    // time, so the rockfall never sounds like a single point source.
    private _frontPos = (getPosATL _anchor) getPos [_length * _progress, _heading];
    _soundSource setPosATL (_frontPos vectorAdd [random 20 - 10, random 20 - 10, 0]);
    _soundSource say3D [selectRandom [QGVAR(murmur), QGVAR(earthquake_2)], 1500];
}, 2, [_anchor, _soundSource, _heading, _length, _duration, CBA_missionTime]] call CBA_fnc_addPerFrameHandler;

// The rock settles before the dust does.
[{
    params ["_boulders", "_stones"];
    deleteVehicle _boulders;
    deleteVehicle _stones;
}, [_boulders, _stones], _duration] call CBA_fnc_waitAndExecute;

[{
    params ["_dust"];
    deleteVehicle _dust;
}, [_dust], _duration + 5] call CBA_fnc_waitAndExecute;
