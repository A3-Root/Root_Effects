#include "..\script_component.hpp"

/*
 * Author: Root
 * Works out where every avalanche boulder goes. Each boulder is released from the
 * head of the slide and simulated in fixed 0.1 s steps: gravity pulls it down, the
 * terrain stops it and bounces it off along the surface normal (so slopes send it
 * rolling downhill), friction slows it and it comes to rest on its own. All random
 * choices come from the shared seed and the steps are fixed, so the server (for
 * damage) and every client (for the picture) get exactly the same paths without
 * anything being sent over the network.
 *
 * Arguments:
 * 0: Head position ATL of the slide <ARRAY>
 * 1: Travel heading in degrees <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Boulder count <NUMBER>
 * 5: Seed <NUMBER>
 *
 * Return Value:
 * Boulders: [[release time, model, scale, radius, positions ASL, rolled distance per step], ...] <ARRAY>
 *
 * Example:
 * [getPosATL _anchor, 120, 200, 25, 40, 1234] call root_effects_volcano_fnc_avalancheRockPaths
 */

params [["_head", [0, 0, 0], [[]], 3], ["_heading", 0, [0]], ["_length", 200, [0]], ["_duration", 25, [0]], ["_count", 40, [0]], ["_seed", 0, [0]]];

#define ROCK_STEP 0.1
#define ROCK_MAX_STEPS 260

private _models = [
    ["\a3\rocks_f\Blunt\BluntStone_01.p3d", 1.4],
    ["\a3\rocks_f\Blunt\BluntStone_02.p3d", 1.3],
    ["\a3\rocks_f\Sharp\sharpStone_01.p3d", 1.2],
    ["\a3\rocks_f\Sharp\sharpStone_02.p3d", 1.2]
];

private _rnd = {params ["_k"]; (_seed + _k) random 1};
private _speed = (_length / _duration) max 4;
private _releaseWindow = _duration * 0.66;
private _rocks = [];

for "_i" from 0 to ((round _count) - 1) do {
    private _k = _i * 17;
    (_models select (floor (([_k] call _rnd) * 3.999))) params ["_model", "_baseRadius"];
    private _scale = 0.18 + ([_k + 1] call _rnd) * 0.32;
    private _radius = _baseRadius * _scale;
    private _release = _releaseWindow * _i / (_count max 1) + ([_k + 2] call _rnd) * 0.5;

    private _start = _head getPos [2 + ([_k + 3] call _rnd) * 10, _heading + ([_k + 4] call _rnd) * 70 - 35];
    private _pos = AGLToASL _start;
    _pos set [2, (getTerrainHeightASL _pos) + _radius + 1.5 + ([_k + 5] call _rnd) * 2];
    private _launch = _speed * (0.8 + ([_k + 6] call _rnd) * 0.6);
    private _vel = [sin _heading * _launch, cos _heading * _launch, 1 + ([_k + 7] call _rnd) * 3];

    private _path = [+_pos];
    private _rolled = [0];
    private _distance = 0;
    private _still = 0;

    for "_s" from 1 to ROCK_MAX_STEPS do {
        _vel = _vel vectorAdd [0, 0, -9.81 * ROCK_STEP];
        private _next = _pos vectorAdd (_vel vectorMultiply ROCK_STEP);
        private _ground = (getTerrainHeightASL _next) + _radius * 0.7;

        if ((_next select 2) <= _ground) then {
            // Hit the ground: bounce off the surface, lose energy, keep rolling.
            _next set [2, _ground];
            private _normal = surfaceNormal _next;
            private _into = _vel vectorDotProduct _normal;
            if (_into < 0) then {
                _vel = _vel vectorDiff (_normal vectorMultiply (1.35 * _into));
            };
            // What is left of gravity runs along the slope, so it rolls downhill;
            // ground contact bleeds off speed.
            _vel = _vel vectorMultiply 0.94;
            // Too slow to keep going: it settles instead of jittering in place.
            if (vectorMagnitude _vel < 1.2) then {
                _vel = [0, 0, 0];
                _still = _still + 1;
            };
        };

        _distance = _distance + (_pos vectorDistance _next);
        _pos = _next;
        _path pushBack +_pos;
        _rolled pushBack _distance;

        // At rest once it has stayed put for a full second.
        if (vectorMagnitude _vel > 0) then {_still = 0};
        if (_still >= 10) exitWith {};
    };

    _rocks pushBack [_release, _model, _scale, _radius, _path, _rolled];
};

_rocks
