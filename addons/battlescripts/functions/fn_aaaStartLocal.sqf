#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side persistent visuals for one anti air barrage instance: a
 * reusable flak flash light plus drifting smoke layers around the barrage
 * altitude. A slow watcher loop creates the visuals in range, removes them
 * out of range and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Barrage radius in meters <NUMBER>
 * 2: Render smoke only, no flash <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 500, false] call root_effects_battlescripts_fnc_aaaStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 500, [0]], ["_smokeOnly", false, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, radius, smokeOnly, visuals]
private _state = [_anchor, _radius, _smokeOnly, []];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_smokeOnly", "_visuals"];

    if (isNull _anchor) exitWith {
        {
            deleteVehicle _x;
        } forEach _visuals;
        _anchor setVariable [QGVAR(aaaLight), nil];
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _viewDistance = (EGVAR(main,maxViewDistance)) max (_radius + 1500);
    private _inRange = (player distance2D _anchor) < _viewDistance;

    if (_inRange && {_visuals isEqualTo []}) then {
        private _budget = (EGVAR(main,particleBudget)) max 0.1;
        private _pos = getPosATL _anchor;

        private _flakLight = "#lightpoint" createVehicleLocal _pos;
        if (!_smokeOnly) then {
            _flakLight setLightIntensity 0;
            _flakLight setLightDayLight true;
            _flakLight setLightUseFlare true;
            _flakLight setLightFlareSize 0;
            _flakLight setLightAttenuation [1000, 0, 100, 0, 1, 50];
            _flakLight setLightFlareMaxDistance 5000;
            _flakLight setLightAmbient [0.9, 0.9, 0.9];
            _flakLight setLightColor [0.9, 0.9, 0.9];
        };
        _visuals pushBack _flakLight;

        // The burst handler moves this light to each detonation point.
        _anchor setVariable [QGVAR(aaaLight), _flakLight];

        private _smokeEmitter = "#particlesource" createVehicleLocal _pos;
        _smokeEmitter setParticleCircle [0, [0, 0, 0]];
        _smokeEmitter setParticleRandom [0.1, [random _radius, random _radius, random 50], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 0, 0];
        _smokeEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 2, 48, 0], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, -1], 0, 0.01, 0.007, 0, [1, 20], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.8], 0, 0, "", "", _flakLight];
        _smokeEmitter setDropInterval (0.05 / _budget);
        _visuals pushBack _smokeEmitter;

        private _smokeColumn = "#particlesource" createVehicleLocal _pos;
        _smokeColumn setParticleCircle [0, [0, 0, 0]];
        _smokeColumn setParticleRandom [0.1, [0, 0, random 10], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 0, 0];
        _smokeColumn setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, -1], 30, 0.01, 0.007, 0, [5, 20, 30, 40], [[0.6, 0.3, 0.2, 0.5], [0, 0, 0, 0.5], [0, 0, 0, 1], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _flakLight];
        _smokeColumn setDropInterval (0.1 / _budget);
        _visuals pushBack _smokeColumn;

        _args set [3, _visuals];
    };

    if (!_inRange && {_visuals isNotEqualTo []}) then {
        {
            deleteVehicle _x;
        } forEach _visuals;
        _args set [3, []];
        _anchor setVariable [QGVAR(aaaLight), nil];
    };
}, 1, _state] call CBA_fnc_addPerFrameHandler;
