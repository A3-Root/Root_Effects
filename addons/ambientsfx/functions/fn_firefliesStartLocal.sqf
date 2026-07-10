#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one firefly swarm: a glittering particle cloud
 * that only exists at night while the player is within activation distance,
 * plus optional ambient frog croaks. A slow watcher loop manages creation
 * and teardown and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Player distance at which the swarm appears <NUMBER>
 * 2: Play ambient frog croaks at night <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 100, true] call root_effects_ambientsfx_fnc_firefliesStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_activationDistance", 100, [0]], ["_frogs", true, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, activationDistance, frogs, emitter, nextCroakTime]
private _state = [_anchor, _activationDistance, _frogs, objNull, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_activationDistance", "_frogs", "_emitter", "_nextCroak"];

    if (isNull _anchor) exitWith {
        deleteVehicle _emitter;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _active = sunOrMoon == 0 && {(player distance _anchor) < _activationDistance};

    if (_active && {isNull _emitter}) then {
        private _fireflyEmitter = "#particlesource" createVehicleLocal getPosATL _anchor;
        _fireflyEmitter setParticleCircle [10, [0, 0, 0]];
        _fireflyEmitter setParticleRandom [10, [5, 5, 2], [0.2, 0.2, 0.5], 1, 0, [0, 0, 0, 0.1], 1, 1];
        _fireflyEmitter setParticleParams [["\A3\data_f\proxies\muzzle_flash\mf_machineGunCheetah.p3d", 1, 0, 1], "", "SpaceObject", 1, 14, [0, 0, 5], [0, 0, 0.5], 13, 1.3, 1, 0, [0.01, 0.01], [[1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 1, "", "", _fireflyEmitter];
        _fireflyEmitter setDropInterval (0.1 / ((EGVAR(main,particleBudget)) max 0.1));
        _args set [3, _fireflyEmitter];
    };

    if (!_active && {!isNull _emitter}) then {
        deleteVehicle _emitter;
        _args set [3, objNull];
    };

    if (_active && _frogs && {CBA_missionTime >= _nextCroak}) then {
        _anchor say3D [QGVAR(frog_croak), 250];
        _args set [4, CBA_missionTime + 15 + random 20];
    };
}, 1, _state] call CBA_fnc_addPerFrameHandler;
