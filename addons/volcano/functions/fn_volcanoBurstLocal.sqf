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

        private _tremor = selectRandom [[QGVAR(earthquake_2), 10], [QGVAR(earthquake_1), 25]];
        playSound (_tremor select 0);
        enableCamShake true;
        addCamShake [0.5, (_tremor select 1) * 2, 25];

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

        [{
            private _tremor = selectRandom [[QGVAR(earthquake_2), 10], [QGVAR(earthquake_1), 25]];
            playSound (_tremor select 0);
            enableCamShake true;
            addCamShake [0.5, (_tremor select 1) * 2, 25];
        }, [], 0.5] call CBA_fnc_waitAndExecute;

        [{
            params ["_rockEmitter"];
            deleteVehicle _rockEmitter;
        }, [_rockEmitter], 1.5] call CBA_fnc_waitAndExecute;

        [{
            params ["_burstEmitter"];
            deleteVehicle _burstEmitter;
        }, [_burstEmitter], 2.5] call CBA_fnc_waitAndExecute;
    };

    case "puff": {
        enableCamShake true;
        addCamShake [0.5, _soundDuration, 25];

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
