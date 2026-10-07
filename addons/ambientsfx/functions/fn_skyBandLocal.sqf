#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Shared client renderer for the aurora borealis and the spacetime rupture.
 * Drops glowing particles along a shaped path above the anchor at night.
 * Normal mode keeps re-sampling the path so the band shimmers, fading each
 * particle in and out at the configured speeds. Fixed mode drops a seeded set
 * of points and keeps refreshing them in place with overlapping lifetimes, so
 * the band looks permanent and never changes shape.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Style, "aurora" or "rupture" <STRING>
 * 2: Shape: 0 band, 1 arc, 2 wave, 3 ring, 4 spiral, 5 random <NUMBER>
 * 3: Fade in time in seconds <NUMBER>
 * 4: Fade out time in seconds <NUMBER>
 * 5: Particle lifetime in seconds <NUMBER>
 * 6: Density 0.1 - 1 <NUMBER>
 * 7: Fixed, no despawn or new spawn <BOOL>
 * 8: Shape seed shared by all clients <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, "aurora", 0, 20, 20, 120, 0.5, false, 1234] call root_effects_ambientsfx_fnc_skyBandLocal
 */

params [
    ["_anchor", objNull, [objNull]],
    ["_style", "aurora", [""]],
    ["_shape", 0, [0]],
    ["_fadeIn", 20, [0]],
    ["_fadeOut", 20, [0]],
    ["_lifetime", 120, [0]],
    ["_density", 0.5, [0]],
    ["_fixed", false, [false]],
    ["_seed", 0, [0]]
];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

private _isAurora = _style isEqualTo "aurora";
_density = (_density max 0.1) min 1;
_lifetime = (_lifetime max 5) min 600;
_fadeIn = (_fadeIn max 0.5) min _lifetime;
_fadeOut = (_fadeOut max 0.5) min _lifetime;

// Fixed bands refresh in place, so a short lifetime keeps teardown quick once
// the anchor goes away. Each refresh overlaps the previous particle's fade.
if (_fixed) then {
    _lifetime = 20;
    _fadeIn = 2;
    _fadeOut = 2;
};

// Seeded shape description so every client draws the same band.
private _rnd = {params ["_k"]; (_seed + _k) random 1};
if (_shape == 5) then {
    _shape = floor (([1] call _rnd) * 5);
};
private _length = [3000, 5000] select _isAurora;
_length = _length * (0.6 + ([2] call _rnd) * 0.8);
private _rotation = ([3] call _rnd) * 360;
private _curl = 0.5 + ([4] call _rnd);

// Path position for t in 0..1 as a model offset from the anchor.
private _fnc_shapePoint = {
    params ["_t"];
    private _p = switch (_shape) do {
        case 1: {
            private _a = (_t - 0.5) * 140 * _curl;
            private _r = _length * 0.6;
            [_r * sin _a, _r * cos _a - _r, 0]
        };
        case 2: {
            [(_t - 0.5) * _length, sin (_t * 360 * 2 * _curl) * _length * 0.1, 0]
        };
        case 3: {
            private _a = _t * 360;
            private _r = _length * 0.3;
            [_r * sin _a, _r * cos _a, 0]
        };
        case 4: {
            private _a = _t * 720 * _curl;
            private _r = _length * (0.04 + _t * 0.3);
            [_r * sin _a, _r * cos _a, _t * _length * 0.05]
        };
        default {
            [(_t - 0.5) * _length, 0, 0]
        };
    };
    _p params ["_px", "_py", "_pz"];
    [_px * cos _rotation - _py * sin _rotation, _px * sin _rotation + _py * cos _rotation, _pz]
};

// Colour keyframes spread evenly over the lifetime, alpha ramped so fade in and
// fade out last the configured number of seconds.
private _fnc_colors = {
    params ["_rgb", "_peak", "_life"];
    private _keys = [];
    for "_i" from 0 to 12 do {
        private _time = _life * _i / 12;
        private _alpha = (_time / _fadeIn) min ((_life - _time) / _fadeOut) min 1 max 0;
        _keys pushBack (_rgb + [_alpha * _peak]);
    };
    _keys
};

private _fnc_drop = {
    params ["_offset", "_t", "_life"];
    if (_isAurora) then {
        // Green curtain shading through teal into violet along the band.
        private _rgb = [
            [0.1, 1, 0.3],
            [0, 0.8, 0.8],
            [0.7, 0.1, 0.9]
        ] select (floor (_t * 2.99));
        private _jitter = [random 10 - 5, random 10 - 5, random 60];
        drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, _life, _offset vectorAdd _jitter, [0, 0, 0], 0, 10, 7.843, 0, [150 + random 100, 200 + random 150], [_rgb, 0.8, _life] call _fnc_colors, [0.08], 0, 0, "", "", _anchor];
    } else {
        private _rgb = [[1, 1, 0.25], [0.5, 1, 0.5]] select (random 1 < 0.4);
        private _jitter = [random 4 - 2, random 4 - 2, random 4 - 2];
        drop [["\A3\data_f\VolumeLight", 1, 0, 1], "", "SpaceObject", 1, _life, _offset vectorAdd _jitter, [0, 0, 0], 0, 10, 7.843, 0, [20 + random 15, 30 + random 15], [_rgb, 1, _life] call _fnc_colors, [0.08], 0, 0, "", "", _anchor];
    };
};

// Fixed mode point set: seeded positions refreshed one after another.
private _points = [];
if (_fixed) then {
    private _count = round (300 * _density * ((EGVAR(main,particleBudget)) max 0.1));
    for "_i" from 0 to (_count - 1) do {
        private _t = (_i + ([10 + _i] call _rnd) * 0.5) / _count;
        _points pushBack [[_t] call _fnc_shapePoint, _t];
    };
};

// Particles per second in normal mode.
private _rate = 20 * _density * ((EGVAR(main,particleBudget)) max 0.1);

// The helpers read their settings from the caller's scope, so everything they
// use is unpacked again by name inside the handler.
// [anchor, nextIndex, carry, ...settings]
private _state = [_anchor, 0, 0, _fixed, _points, _rate, _lifetime, _fnc_shapePoint, _fnc_drop, _fnc_colors, _shape, _length, _rotation, _curl, _isAurora, _fadeIn, _fadeOut];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_nextIndex", "_carry", "_fixed", "_points", "_rate", "_lifetime", "_fnc_shapePoint", "_fnc_drop", "_fnc_colors", "_shape", "_length", "_rotation", "_curl", "_isAurora", "_fadeIn", "_fadeOut"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Paused by the termination module, or daytime: keep what is already in
    // the sky but drop nothing new.
    if (_anchor getVariable [QEGVAR(main,paused), false]) exitWith {};
    if (sunOrMoon != 0) exitWith {};

    if (_fixed) then {
        // Each point is redropped every 90% of its lifetime so the incoming
        // fade overlaps the outgoing one and the band never blinks.
        private _count = count _points;
        if (_count == 0) exitWith {};
        private _perTick = (_count * 0.25 / (_lifetime * 0.9)) + _carry;
        private _n = floor _perTick;
        _args set [2, _perTick - _n];
        for "_i" from 1 to _n do {
            (_points select _nextIndex) params ["_offset", "_t"];
            [_offset, _t, _lifetime] call _fnc_drop;
            _nextIndex = (_nextIndex + 1) mod _count;
        };
        _args set [1, _nextIndex];
    } else {
        private _perTick = (_rate * 0.25) + _carry;
        private _n = floor _perTick;
        _args set [2, _perTick - _n];
        for "_i" from 1 to _n do {
            private _t = random 1;
            [[_t] call _fnc_shapePoint, _t, _lifetime * (0.6 + random 0.4)] call _fnc_drop;
        };
    };
}, 0.25, _state] call CBA_fnc_addPerFrameHandler;
