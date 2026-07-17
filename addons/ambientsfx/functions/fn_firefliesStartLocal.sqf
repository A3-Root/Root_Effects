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
        // Glowing billboard sprite; the colour animation makes each firefly
        // fade in and out so the swarm twinkles.
        _fireflyEmitter setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 14, [0, 0, 5], [0, 0, 0.5], 13, 1.3, 1, 0, [0.16], [[0.75, 1, 0.35, 0], [0.9, 1, 0.5, 1], [0.75, 1, 0.35, 0]], [1], 1, 1, "", "", _fireflyEmitter];
        _fireflyEmitter setDropInterval (0.1 / ((EGVAR(main,particleBudget)) max 0.1));
        _args set [3, _fireflyEmitter];
    };

    if (!_active && {!isNull _emitter}) then {
        deleteVehicle _emitter;
        _args set [3, objNull];
    };

    if (_active && _frogs && {CBA_missionTime >= _nextCroak}) then {
        // Not every window produces a croak, which keeps the pond from
        // sounding metronomic. The timer advances either way.
        if (random 1 < 0.6) then {
            _anchor say3D [QGVAR(frog_croak), 80];
        };
        _args set [4, CBA_missionTime + 45 + random 75];
    };
}, 1, _state] call CBA_fnc_addPerFrameHandler;
