#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Particle timer callback of the large eruption puff. Spawns a short lived
 * ground smoke ring, plays a tremor rumble and shakes the camera. The engine
 * calls this with _this set to the particle position.
 */

private _effectPos = _this;

private _smokeEmitter = "#particlesource" createVehicleLocal _effectPos;
_smokeEmitter setParticleCircle [20, [0, 0, 0]];
_smokeEmitter setParticleRandom [0, [0, 0, 0], [50, 50, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_smokeEmitter setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 0], [0, 0, 30], 3, 150, 1, 0, [50, 100, 150], [[0.1, 0.1, 0.1, 1], [0, 0, 0, 1], [0, 0, 0, 0]], [1000], 1, 0, "", "", _effectPos];
_smokeEmitter setDropInterval 0.005;

private _tremor = selectRandom [[QGVAR(earthquake_2), 10], [QGVAR(earthquake_1), 25]];
playSound (_tremor select 0);
enableCamShake true;
addCamShake [0.5, (_tremor select 1) * 2, 25];

[{
    params ["_smokeEmitter"];
    deleteVehicle _smokeEmitter;
}, [_smokeEmitter], 0.5] call CBA_fnc_waitAndExecute;
