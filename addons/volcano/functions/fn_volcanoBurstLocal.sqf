#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Plays one eruption burst on this client: eruption roar, particle blast of
 * the given type, camera shake, ground tremor and a distant echo. Everything
 * is created locally and cleans itself up after a few seconds.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Crater radius in meters <NUMBER>
 * 2: Burst type "sparks", "shrapnel" or "puff" <STRING>
 * 3: Eruption sound class <STRING>
 * 4: Eruption sound duration in seconds <NUMBER>
 * 5: Eruption echo sound class <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 120, "sparks", "root_effects_volcano_eruption_1", 10, "root_effects_volcano_eruption_1_echo"] call root_effects_volcano_fnc_volcanoBurstLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 120, [0]], ["_burstType", "sparks", [""]], ["_sound", "", [""]], ["_soundDuration", 10, [0]], ["_echoSound", "", [""]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};
if ((player distance2D _anchor) > ((EGVAR(main,maxViewDistance)) max 3000)) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;
private _pos = getPosATL _anchor;

// A single shake fires once and dies, which reads as a bump rather than an
// eruption. Staging it gives an initial jolt, a sustained tremor scaled to how
// big the mountain is, and a long settling tail. Distance takes the edge off.
private _fnc_tremor = {
    params ["_anchor", "_radius", "_soundDuration"];

    private _distance = player distance2D _anchor;
    private _falloff = linearConversion [500, 4000, _distance, 1, 0.1, true];
    private _size = linearConversion [50, 300, _radius, 0.6, 1.6, true];

    enableCamShake true;
    addCamShake [3 * _size * _falloff, 2, 30];

    [{
        params ["_size", "_falloff", "_soundDuration"];
        addCamShake [1.2 * _size * _falloff, _soundDuration max 8, 20];

        [{
            params ["_size", "_falloff"];
            addCamShake [0.4 * _size * _falloff, 25, 12];
        }, [_size, _falloff], (_soundDuration max 8) * 0.6] call CBA_fnc_waitAndExecute;
    }, [_size, _falloff, _soundDuration], 1.5] call CBA_fnc_waitAndExecute;
};

_anchor say3D [_sound, 5000];

// Distant rumble echo once the initial blast has played out.
[{
    params ["_anchor", "_echoSound"];
    if (!isNull _anchor && {(player distance _anchor) < 3000}) then {
        playSound _echoSound;
    };
}, [_anchor, _echoSound], 2.5] call CBA_fnc_waitAndExecute;

switch (_burstType) do {
    case "sparks": {
        private _sparkEmitter = "#particlesource" createVehicleLocal _pos;
        _sparkEmitter setParticleCircle [_radius / 3, [0, 0, 0]];
        _sparkEmitter setParticleRandom [0, [0, 0, 0], [30, 30, 20], 0, 0, [0, 0, 0, 0], 1, 0];
        _sparkEmitter setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 10, [0, 0, 20], [0, 0, 50], 0, 10, 8, 0, [50, 150, 200], [[0.1, 0.1, 0.1, 0.5], [0, 0, 0, 1], [0, 0, 0, 0]], [0.5], 1, 0, "", "", _anchor];
        _sparkEmitter setDropInterval (0.05 / _budget);

        private _chunkEmitter = "#particlesource" createVehicleLocal _pos;
        _chunkEmitter setParticleCircle [_radius / 4, [0, 0, 0]];
        _chunkEmitter setParticleRandom [4, [_radius / 10, _radius / 10, 10], [80, 80, 30], 0, 0.1, [0, 0, 0, 1], 1, 1];
        _chunkEmitter setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 2, [10, 0, 20], [0, 0, 60], 0, 30, 6, 0, [3, 1], [[1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 1, "", "", _anchor];
        _chunkEmitter setDropInterval (0.01 / _budget);

        drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 7, [0, 0, 20], [0, 0, 80], 0, 500, 5, 0, [100, 200, 300], [[1, 0.7, 0, 1], [1, 0.7, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _anchor];
        [{
            params ["_anchor"];
            if (isNull _anchor) exitWith {};
            drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 7, [0, 0, 10], [0, 0, 100], 0, 500, 5, 0, [100, 200, 300], [[1, 0.7, 0, 1], [1, 0.7, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _anchor];
        }, [_anchor], 0.3] call CBA_fnc_waitAndExecute;

        playSound (selectRandom [QGVAR(earthquake_2), QGVAR(earthquake_1)]);
        [_anchor, _radius, _soundDuration] call _fnc_tremor;

        [{
            params ["_sparkEmitter", "_chunkEmitter"];
            deleteVehicle _sparkEmitter;
            deleteVehicle _chunkEmitter;
        }, [_sparkEmitter, _chunkEmitter], 2] call CBA_fnc_waitAndExecute;
    };

    case "shrapnel": {
        private _burstEmitter = "#particlesource" createVehicleLocal _pos;
        _burstEmitter setParticleCircle [_radius / 3, [0, 0, 0]];
        _burstEmitter setParticleRandom [0, [0, 0, 0], [50, 50, 20], 0, 0, [0, 0, 0, 0], 1, 0];
        _burstEmitter setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 10, [0, 0, 20], [0, 0, 50], 0, 10, 8, 0, [50, 150, 200], [[0.1, 0.1, 0.1, 0.5], [0, 0, 0, 1], [0, 0, 0, 0]], [0.5], 1, 0, "", "", _anchor];
        _burstEmitter setDropInterval (0.02 / _budget);

        private _rockEmitter = "#particlesource" createVehicleLocal _pos;
        _rockEmitter setParticleCircle [_radius / 3, [0, 0, 0]];
        _rockEmitter setParticleRandom [5, [10, 10, 50], [100, 100, 50], 0.5, 0.5, [0, 0, 0, 1], 1, 0];
        if (selectRandom [true, false]) then {
            // Smoke trails behind the ejected rocks shrink over time; the
            // trail callback derives its size from this timestamp.
            GVAR(rockTrailStart) = diag_tickTime;
            _rockEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 0.05, 7, [0, 0, 0], [0, 0, 150], 1, 1000, 5, 0, [8, 8, 0.1], [[0, 0, 0, 1], [0, 0, 0, 1], [0.5, 0.5, 0.5, 1]], [0.125], 1, 0, QPATHTOF(functions\fn_volcanoRockTrail.sqf), "", _anchor];
        } else {
            _rockEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 7, [0, 0, 0], [0, 0, 150], 1, 1000, 5, 0, [8, 8, 0.1], [[0, 0, 0, 1], [0, 0, 0, 1], [0.5, 0.5, 0.5, 1]], [0.125], 1, 0, "", "", _anchor];
        };
        _rockEmitter setDropInterval (0.05 / _budget);

        // Heavy lava bombs on ballistic arcs that bounce where they land,
        // trailing dust as they tumble down the slopes.
        private _bombEmitter = "#particlesource" createVehicleLocal _pos;
        _bombEmitter setParticleCircle [_radius / 4, [0, 0, 0]];
        _bombEmitter setParticleRandom [3, [15, 15, 20], [60, 60, 40], 0, 0.4, [0, 0, 0, 0.2], 1, 0];
        _bombEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12, [0, 0, 10], [0, 0, 110], 1, 400, 6, 0, [4, 4, 3], [[1, 0.5, 0.05, 1], [0.8, 0.25, 0.02, 1], [0.2, 0.15, 0.12, 1]], [0.2, 0.6], 1, 0, "", "", _anchor, 0, true, 0.5, [[0, 0, 0, 0]]];
        _bombEmitter setDropInterval (0.12 / _budget);

        private _bombDust = "#particlesource" createVehicleLocal _pos;
        _bombDust setParticleCircle [_radius / 2, [0, 0, 0]];
        _bombDust setParticleRandom [2, [_radius / 3, _radius / 3, 2], [4, 4, 2], 0, 0.4, [0, 0, 0, 0.1], 0, 0];
        _bombDust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 5, [0, 0, 1], [0, 0, 2], 0, 10, 7.5, 0.05, [3, 12], [[0.35, 0.32, 0.28, 0.6], [0.4, 0.38, 0.35, 0.3], [0.45, 0.42, 0.4, 0]], [0.4, 1], 1, 0, "", "", _anchor];
        _bombDust setDropInterval (0.08 / _budget);

        [{
            params ["_anchor", "_radius", "_soundDuration", "_fnc_tremor"];
            playSound (selectRandom [QGVAR(earthquake_2), QGVAR(earthquake_1)]);
            [_anchor, _radius, _soundDuration] call _fnc_tremor;
        }, [_anchor, _radius, _soundDuration, _fnc_tremor], 0.5] call CBA_fnc_waitAndExecute;

        [{
            params ["_rockEmitter", "_bombEmitter"];
            deleteVehicle _rockEmitter;
            deleteVehicle _bombEmitter;
        }, [_rockEmitter, _bombEmitter], 1.5] call CBA_fnc_waitAndExecute;

        [{
            params ["_bombDust"];
            deleteVehicle _bombDust;
        }, [_bombDust], 6] call CBA_fnc_waitAndExecute;

        [{
            params ["_burstEmitter"];
            deleteVehicle _burstEmitter;
        }, [_burstEmitter], 2.5] call CBA_fnc_waitAndExecute;
    };

    case "puff": {
        [_anchor, _radius, _soundDuration] call _fnc_tremor;

        drop [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 1, 15, 1], "", "Billboard", 0.8, 1, [0, 0, 50], [0, 0, 100], 0, 10, 8, 0, [(_radius / 10) * 50, (_radius / 10) * 60, (_radius / 10) * 2], [[1, 1, 1, 0.5], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 0, QPATHTOF(functions\fn_volcanoSmokePuff.sqf), "", _anchor];
        [{
            params ["_anchor", "_radius"];
            if (isNull _anchor) exitWith {};
            drop [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 1, 15, 0], "", "Billboard", 1, 1, [0, 0, 50], [0, 0, 50], 0, 10, 8, 0, [(_radius / 10) * 50, (_radius / 10) * 60, (_radius / 10) * 2], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 0, "", "", _anchor];
        }, [_anchor, _radius], 0.3] call CBA_fnc_waitAndExecute;

        private _lavaEmitter = "#particlesource" createVehicleLocal _pos;
        _lavaEmitter setParticleCircle [_radius / 3, [0, 0, 0]];
        _lavaEmitter setParticleRandom [1, [0, 0, 10], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 0, 0];
        _lavaEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 13, [0, 0, 50], [0, 0, 50], 0, 50, 7, 0, [_radius * 3, _radius * 8], [[1, 0.7, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _anchor];
        _lavaEmitter setDropInterval (0.1 / _budget);

        [{
            params ["_lavaEmitter"];
            deleteVehicle _lavaEmitter;

            private _tremor = selectRandom [QGVAR(earthquake_2), QGVAR(earthquake_1)];
            playSound _tremor;
        }, [_lavaEmitter], 1] call CBA_fnc_waitAndExecute;
    };
};
