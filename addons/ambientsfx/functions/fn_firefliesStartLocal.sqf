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
DBG(FORMAT_1("firefliesStartLocal running here with %1",_this));

// Builds a random blink pattern for the next batch of fireflies: a few pulses
// of differing length with dark gaps between, ending dark. Colour and emissive
// keyframes share the timing so the sprite glows in the dark and dims together.
private _fnc_blinkParams = {
    params ["_emitter"];

    private _colors = [[0.6, 0.9, 0.2, 0]];
    private _emissive = [[0, 0, 0, 0]];
    for "_p" from 1 to (1 + floor random 3) do {
        private _peak = 0.4 + random 0.6;
        for "_k" from 1 to (1 + floor random 2) do {
            _colors pushBack [0.7, 1, 0.25, _peak];
            _emissive pushBack [60 * _peak, 110 * _peak, 15 * _peak, _peak];
        };
        // Dark gap, sometimes only a dip rather than a full off.
        private _rest = [0, 0.1 * _peak] select (random 1 < 0.3);
        _colors pushBack [0.6, 0.9, 0.2, _rest];
        _emissive pushBack [60 * _rest, 110 * _rest, 15 * _rest, _rest];
    };
    _colors pushBack [0.6, 0.9, 0.2, 0];
    _emissive pushBack [0, 0, 0, 0];

    _emitter setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 6 + random 10, [0, 0, 1.5], [0, 0, 0.1], 13, 1.3, 1, 0.05, [0.12 + random 0.1], _colors, [1], 1.5, 0.4, "", "", _emitter, 0, false, 0, _emissive];
};

// [anchor, activationDistance, frogs, emitter, nextCroakTime]
private _state = [_anchor, _activationDistance, _frogs, objNull, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_activationDistance", "_frogs", "_emitter", "_nextCroak", "_fnc_blinkParams"];

    if (isNull _anchor) exitWith {
        deleteVehicle _emitter;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _active = sunOrMoon == 0 && {(player distance _anchor) < _activationDistance};

    if (_active && {isNull _emitter}) then {
        private _fireflyEmitter = "#particlesource" createVehicleLocal getPosATL _anchor;
        _fireflyEmitter setParticleCircle [10, [0, 0, 0]];
        _fireflyEmitter setParticleRandom [4, [8, 8, 1.5], [0.3, 0.3, 0.2], 1, 0.05, [0, 0, 0, 0], 0.5, 0.2];
        [_fireflyEmitter] call _fnc_blinkParams;
        _fireflyEmitter setDropInterval (0.15 / ((EGVAR(main,particleBudget)) max 0.1));
        _args set [3, _fireflyEmitter];
        _emitter = _fireflyEmitter;
        DBG(FORMAT_1("fireflies active near %1",mapGridPosition _anchor));
    };

    if (!_active && {!isNull _emitter}) then {
        deleteVehicle _emitter;
        _args set [3, objNull];
    };

    if (_active) then {
        // New blink pattern for the next particles so no two flash in step.
        [_emitter] call _fnc_blinkParams;
    };

    if (_active && _frogs && CBA_missionTime >= _nextCroak) then {
        // Not every window produces a croak, which keeps the pond from
        // sounding metronomic. The timer advances either way.
        if (random 1 < 0.6) then {
            _anchor say3D [QGVAR(frog_croak), 80];
        };
        _args set [4, CBA_missionTime + 45 + random 75];
    };
}, 0.25, _state + [_fnc_blinkParams]] call CBA_fnc_addPerFrameHandler;
