#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Shared client renderer for the aurora borealis and the spacetime rupture.
 * Drops glowing particles along a shaped path above the anchor at night. Every
 * tick it reads the live sky settings the server keeps on the anchor (see
 * skyServer), so the Modify Sky Effect module can change it on the fly:
 * - new particles on or off,
 * - particles allowed to fade out, or kept alive in place for good,
 * - particle size and band length,
 * - shape and seed (the server re-rolls them on the shape switch timer).
 * With fading off, every particle that is visible right then (and any new one)
 * is re-dropped at the same spot before it would fade, so the band holds exactly
 * as it is. The anchor itself can move; new drops follow it.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Style, "aurora" or "rupture" <STRING>
 * 2: Fade in time in seconds <NUMBER>
 * 3: Fade out time in seconds <NUMBER>
 * 4: Particle lifetime in seconds <NUMBER>
 * 5: Density 0.1 - 1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, "aurora", 20, 20, 120, 0.5] call root_effects_ambientsfx_fnc_skyBandLocal
 */

params [
    ["_anchor", objNull, [objNull]],
    ["_style", "aurora", [""]],
    ["_fadeIn", 20, [0]],
    ["_fadeOut", 20, [0]],
    ["_lifetime", 120, [0]],
    ["_density", 0.5, [0]]
];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

private _isAurora = _style isEqualTo "aurora";
_density = (_density max 0.1) min 1;
_lifetime = (_lifetime max 5) min 600;
_fadeIn = (_fadeIn max 0.5) min _lifetime;
_fadeOut = (_fadeOut max 0.5) min _lifetime;

DBG(FORMAT_4("%1 renderer start, lifetime %2, density %3, at %4",_style,_lifetime,_density,mapGridPosition _anchor));

// Lifetime of a kept particle; each is re-dropped before it starts to fade.
#define KEEP_LIFE 20
#define KEEP_FADE 2
#define KEEP_CAP 500

// Shape description from the shape id and seed, shared by all clients.
// Returns [shape, base length, rotation, curl].
private _fnc_shapeInfo = {
    params ["_shape", "_seed"];
    private _rnd = {params ["_k"]; (_seed + _k) random 1};
    if (_shape == 5) then {
        _shape = floor (([1] call _rnd) * 5);
    };
    private _length = [3000, 5000] select _isAurora;
    _length = _length * (0.6 + ([2] call _rnd) * 0.8);
    [_shape, _length, ([3] call _rnd) * 360, 0.5 + ([4] call _rnd)]
};

// Path position for t in 0..1 as a model offset from the anchor.
private _fnc_shapePoint = {
    params ["_t", "_info", "_lengthScale"];
    _info params ["_shape", "_baseLength", "_rotation", "_curl"];
    private _length = _baseLength * _lengthScale;
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
// fade out last the given number of seconds.
private _fnc_colors = {
    params ["_rgb", "_peak", "_life", "_in", "_out"];
    private _keys = [];
    for "_i" from 0 to 12 do {
        private _time = _life * _i / 12;
        private _alpha = (_time / _in) min ((_life - _time) / _out) min 1 max 0;
        _keys pushBack (_rgb + [_alpha * _peak]);
    };
    _keys
};

// A particle descriptor: [t along the path, jitter, colour roll, size roll].
private _fnc_newDesc = {
    params ["_t"];
    [_t, [random 1, random 1, random 1], random 1, [random 1, random 1]]
};

private _fnc_drop = {
    params ["_desc", "_life", "_in", "_out", "_info", "_sizeScale", "_lengthScale"];
    _desc params ["_t", "_jitter", "_colourRoll", "_sizeRoll"];
    private _offset = [_t, _info, _lengthScale] call _fnc_shapePoint;
    if (_isAurora) then {
        // Green curtain shading through teal into violet along the band.
        private _rgb = [[0.1, 1, 0.3], [0, 0.8, 0.8], [0.7, 0.1, 0.9]] select (floor (_t * 2.99));
        _offset = _offset vectorAdd [(_jitter select 0) * 10 - 5, (_jitter select 1) * 10 - 5, (_jitter select 2) * 60 * _sizeScale];
        private _size = [(150 + (_sizeRoll select 0) * 100) * _sizeScale, (200 + (_sizeRoll select 1) * 150) * _sizeScale];
        drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, _life, _offset, [0, 0, 0], 0, 10, 7.843, 0, _size, [_rgb, 0.8, _life, _in, _out] call _fnc_colors, [0.08], 0, 0, "", "", _anchor];
    } else {
        private _rgb = [[1, 1, 0.25], [0.5, 1, 0.5]] select (_colourRoll < 0.4);
        _offset = _offset vectorAdd [(_jitter select 0) * 4 - 2, (_jitter select 1) * 4 - 2, (_jitter select 2) * 4 - 2];
        private _size = [(20 + (_sizeRoll select 0) * 15) * _sizeScale, (30 + (_sizeRoll select 1) * 15) * _sizeScale];
        drop [["\A3\data_f\VolumeLight", 1, 0, 1], "", "SpaceObject", 1, _life, _offset, [0, 0, 0], 0, 10, 7.843, 0, _size, [_rgb, 1, _life, _in, _out] call _fnc_colors, [0.08], 0, 0, "", "", _anchor];
    };
};

// Particles per second while new particles are allowed.
private _rate = 20 * _density * ((EGVAR(main,particleBudget)) max 0.1);

// [anchor, carry, recent, kept, lastDespawn, shapeKey, info, settings...]
// recent: [desc, born, life] of the latest drops, so they can be kept on demand.
// kept: [desc, nextDrop] of particles held in place.
private _state = [
    _anchor, 0, [], [], true, [], [],
    _rate, _lifetime, _fadeIn, _fadeOut, _isAurora,
    _fnc_shapeInfo, _fnc_shapePoint, _fnc_colors, _fnc_newDesc, _fnc_drop
];

[{
    params ["_args", "_handle"];
    _args params [
        "_anchor", "_carry", "_recent", "_kept", "_lastDespawn", "_shapeKey", "_info",
        "_rate", "_lifetime", "_fadeIn", "_fadeOut", "_isAurora",
        "_fnc_shapeInfo", "_fnc_shapePoint", "_fnc_colors", "_fnc_newDesc", "_fnc_drop"
    ];

    if (isNull _anchor) exitWith {
        DBG("sky renderer teardown");
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Live settings from the server: [spawn, despawn, size, length, shape, seed].
    (_anchor getVariable [QGVAR(skyCfg), [true, true, 1, 1, 0, 0]]) params ["_spawn", "_despawn", "_sizeScale", "_lengthScale", "_shape", "_seed"];

    if (_shapeKey isNotEqualTo [_shape, _seed]) then {
        _info = [_shape, _seed] call _fnc_shapeInfo;
        _args set [5, [_shape, _seed]];
        _args set [6, _info];
    };

    private _now = CBA_missionTime;

    // Fading switched off: everything visible right now is taken over and held.
    if (!_despawn && _lastDespawn) then {
        {
            _x params ["_desc", "_born", "_life"];
            if (_born + _life > _now) then {
                _kept pushBack [_desc, (_born + _life - _fadeOut) max _now];
            };
        } forEach _recent;
        _recent resize 0;
        DBG(FORMAT_1("sky effect holding %1 particles in place",count _kept));
    };
    // Fading switched back on: held particles simply run out and fade.
    if (_despawn && !_lastDespawn) then {
        _kept resize 0;
    };
    _args set [4, _despawn];

    // Paused by the termination module, or daytime: drop nothing new.
    if (_anchor getVariable [QEGVAR(main,paused), false]) exitWith {};
    if (sunOrMoon != 0) exitWith {};

    if (_spawn && {_despawn || {count _kept < KEEP_CAP}}) then {
        private _perTick = (_rate * 0.25) + _carry;
        private _n = floor _perTick;
        _args set [1, _perTick - _n];
        for "_i" from 1 to _n do {
            private _desc = [random 1] call _fnc_newDesc;
            if (_despawn) then {
                private _life = _lifetime * (0.6 + random 0.4);
                [_desc, _life, _fadeIn, _fadeOut, _info, _sizeScale, _lengthScale] call _fnc_drop;
                _recent pushBack [_desc, _now, _life];
            } else {
                [_desc, KEEP_LIFE, _fadeIn min KEEP_LIFE, KEEP_FADE, _info, _sizeScale, _lengthScale] call _fnc_drop;
                if (count _kept < KEEP_CAP) then {
                    _kept pushBack [_desc, _now + KEEP_LIFE - KEEP_FADE];
                };
            };
        };
        // Forget particles that have long faded.
        if (count _recent > 800) then {_recent deleteRange [0, count _recent - 800]};
    };

    // Re-drop held particles just before they would start to fade, so the
    // incoming copy overlaps the outgoing one and nothing blinks.
    if (!_despawn) then {
        private _budget = 40;
        {
            _x params ["_desc", "_next"];
            if (_now >= _next && _budget > 0) then {
                [_desc, KEEP_LIFE, KEEP_FADE, KEEP_FADE, _info, _sizeScale, _lengthScale] call _fnc_drop;
                _x set [1, _now + KEEP_LIFE - KEEP_FADE];
                _budget = _budget - 1;
            };
        } forEach _kept;
    };
}, 0.25, _state] call CBA_fnc_addPerFrameHandler;
