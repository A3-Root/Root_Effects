#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts animating one floating object on the server. A single loop combines
 * slide, bounce, rotation, rollover and orbit into one position and attitude
 * update per tick, so the object moves identically for everyone with one
 * authoritative mover instead of competing per client loops. Stopping the
 * instance restores the object to its original state.
 *
 * Arguments:
 * 0: Object to animate <OBJECT>
 * 1: Hover elevation above terrain in meters <NUMBER>
 * 2: Object can take damage <BOOL>
 * 3: Keep object simulation enabled <BOOL>
 * 4: Slide as [stepPerTick, maxDistance] <ARRAY>
 * 5: Bounce as [stepPerTick, amplitude] <ARRAY>
 * 6: Rotation as [degreesPerTick, clockwise] <ARRAY>
 * 7: Rollover pitch step per tick <NUMBER>
 * 8: Orbit as [radius, degreesPerTick, clockwise] <ARRAY>
 * 9: Player distance required for the animation to run <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object, 5, true, false, [0, 0], [0, 0], [1, true], 0, [0, 0.1, true], 9999] call root_effects_floatingobjects_fnc_floatingStart
 */

params [
    ["_object", objNull, [objNull]],
    ["_elevation", 5, [0]],
    ["_allowDamage", true, [false]],
    ["_allowSimulation", false, [false]],
    ["_slide", [0, 0], [[]], 2],
    ["_bounce", [0, 0], [[]], 2],
    ["_rotation", [0, true], [[]], 2],
    ["_rollStep", 0, [0]],
    ["_orbit", [0, 0, true], [[]], 3],
    ["_actDist", 9999, [0]]
];

if (!isServer) exitWith {};
if (!(["floatingobjects"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (isNull _object) exitWith {};
if (_object getVariable [QGVAR(active), false]) exitWith {};

_object setVariable [QGVAR(active), true];

// Remember the original state so stopping the effect can restore it.
private _originalPos = getPosATL _object;
private _originalDir = getDir _object;

_object allowDamage _allowDamage;
_object enableSimulationGlobal _allowSimulation;

private _basePos = +_originalPos;
_basePos set [2, _elevation];
_object setPosATL _basePos;

private _anchor = ["floatingobjects", "", [], getPosATL _object] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

_slide params ["_slideStep", "_slideDist"];
_bounce params ["_bounceStep", "_bounceAmp"];
_rotation params ["_rotStep", "_rotCw"];
_orbit params ["_orbitRadius", "_orbitStep", "_orbitCw"];

if (!_rotCw) then {
    _rotStep = -_rotStep;
};
if (!_orbitCw) then {
    _orbitStep = -_orbitStep;
};

// [anchor, object, basePos, elevation, restore data, per mode progress]
private _state = [
    _anchor, _object, _basePos, _elevation, [_originalPos, _originalDir],
    _slideStep, _slideDist, 0, 1,
    _bounceStep, _bounceAmp, 0, 1,
    _rotStep, _originalDir,
    _rollStep, 0, 1,
    _orbitRadius, _orbitStep, 0,
    _actDist
];

[{
    params ["_args", "_handle"];
    _args params [
        "_anchor", "_object", "_basePos", "_elevation", "_restore",
        "_slideStep", "_slideDist", "_slideOffset", "_slideSign",
        "_bounceStep", "_bounceAmp", "_bounceOffset", "_bounceSign",
        "_rotStep", "_heading",
        "_rollStep", "_pitch", "_pitchSign",
        "_orbitRadius", "_orbitStep", "_orbitAngle",
        "_actDist"
    ];

    if (isNull _anchor || {isNull _object}) exitWith {
        if (!isNull _object) then {
            _restore params ["_originalPos", "_originalDir"];
            _object setVectorDirAndUp [[0, 1, 0], [0, 0, 1]];
            _object setDir _originalDir;
            _object setPosATL _originalPos;
            _object allowDamage true;
            _object enableSimulationGlobal true;
            _object setVariable [QGVAR(active), nil];
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Suspend the animation while nobody is near enough to see it.
    if (_actDist < 9999 && {(allPlayers findIf {(_x distance _object) < _actDist}) == -1}) exitWith {};

    // Advance the oscillating offsets.
    if (_slideStep > 0) then {
        _slideOffset = _slideOffset + _slideStep * _slideSign;
        if (_slideOffset >= _slideDist) then {
            _args set [8, -1];
        };
        if (_slideOffset <= 0) then {
            _args set [8, 1];
        };
        _args set [7, _slideOffset];
    };

    if (_bounceStep > 0) then {
        _bounceOffset = _bounceOffset + _bounceStep * _bounceSign;
        if (_bounceOffset >= _bounceAmp) then {
            _args set [12, -1];
        };
        if (_bounceOffset <= -_bounceAmp) then {
            _args set [12, 1];
        };
        _args set [11, _bounceOffset];
    };

    if (_rotStep != 0) then {
        _heading = (_heading + _rotStep) mod 360;
        _args set [14, _heading];
    };

    if (_rollStep > 0) then {
        _pitch = _pitch + _rollStep * _pitchSign;
        if (_pitch >= 86) then {
            _args set [17, -1];
        };
        if (_pitch <= 0) then {
            _args set [17, 1];
        };
        _args set [16, _pitch];
    };

    if (_orbitStep != 0 && {_orbitRadius > 0}) then {
        _orbitAngle = (_orbitAngle + _orbitStep) mod 360;
        _args set [20, _orbitAngle];
    };

    // Compose the final transform from all active modes.
    private _newPos = +_basePos;
    if (_orbitRadius > 0) then {
        private _orbitPos = _basePos getPos [_orbitRadius, _orbitAngle];
        _newPos set [0, _orbitPos select 0];
        _newPos set [1, _orbitPos select 1];
    };
    if (_slideOffset > 0) then {
        private _slidePos = _newPos getPos [_slideOffset, _heading];
        _newPos set [0, _slidePos select 0];
        _newPos set [1, _slidePos select 1];
    };
    _newPos set [2, _elevation + _bounceOffset];

    _object setDir _heading;
    if (_rollStep > 0) then {
        private _dirVector = [sin _heading * cos _pitch, cos _heading * cos _pitch, sin _pitch];
        private _upVector = [sin _heading * -(sin _pitch), cos _heading * -(sin _pitch), cos _pitch];
        _object setVectorDirAndUp [_dirVector, _upVector];
    };
    _object setPosATL _newPos;
}, 0.05, _state] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_1("floating object animation started on %1",typeOf _object));
