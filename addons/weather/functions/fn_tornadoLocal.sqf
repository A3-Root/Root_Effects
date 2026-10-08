#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side tornado for a lightning storm: a towering funnel of dark cloud that
 * widens with height and spins, a cloud wall at the top, a ring of dust and debris
 * whipped around its foot, a howling wind and a rumble that shakes the camera when
 * it passes close. It follows the shared seeded path, so every client sees it in
 * the same place, and goes away with the storm anchor.
 *
 * Arguments:
 * 0: Storm anchor <OBJECT>
 * 1: Storm radius in meters <NUMBER>
 * 2: Funnel width at the top in meters <NUMBER>
 * 3: Travel speed in m/s <NUMBER>
 * 4: Path seed <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 300, 120, 8, 1234] call root_effects_weather_fnc_tornadoLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 300, [0]], ["_size", 120, [0]], ["_speed", 8, [0]], ["_seed", 0, [0]]];

DBG(FORMAT_1("tornadoLocal called with %1",_this));

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;
private _center = getPosATL _anchor;
private _pos = [_center, _radius, _speed, _seed] call FUNC(tornadoPos);

DBG(FORMAT_3("tornado local start, width %1, speed %2, at %3",_size,_speed,mapGridPosition _pos));

// Funnel: a tight, tapering rope at the ground that flares into a wide cone
// under the cloud. Forty thin layers, each puff no wider than its ring, so the
// outline reads as a funnel instead of a blob. Animated smoke frames give it a
// churning texture; dusty brown at the foot shading into storm grey above. Puffs
// are as heavy as the air and each layer spins through its circle velocity.
private _rings = [];
private _layers = 40;
private _topHeight = 420;
private _spacing = _topHeight / (_layers - 1);
for "_i" from 0 to (_layers - 1) do {
    private _t = _i / (_layers - 1);
    private _height = 1 + _t * _topHeight;
    private _ringRadius = (_size * 0.04) + (_size * 0.55) * (_t ^ 2.2);
    private _puff = (_spacing * 1.4) max (_ringRadius * 0.85);
    private _spin = 6 + 10 * _t;
    private _life = 4 + 2 * _t;
    private _puffs = 6 max ((2 * pi * _ringRadius) / (_puff * 0.5));
    private _rgb = [
        0.3 - 0.14 * _t,
        0.27 - 0.12 * _t,
        0.23 - 0.08 * _t
    ];
    private _alpha = 0.55 + 0.25 * _t;
    private _ring = "#particlesource" createVehicleLocal _pos;
    _ring setParticleCircle [_ringRadius, [_spin, _spin, 0]];
    _ring setParticleRandom [1, [_ringRadius * 0.08, _ringRadius * 0.08, _spacing * 0.5], [0.8, 0.8, 0.6], 2, _puff * 0.12, [0.02, 0.02, 0.02, 0.05], 0, 0];
    _ring setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 7, 48, 1], "", "Billboard", 1, _life, [0, 0, _height], [0, 0, 2], 2, 7.9, 7.9, 0.25, [_puff * 0.7, _puff, _puff * 1.15], [_rgb + [0], _rgb + [_alpha], _rgb + [_alpha * 0.8], _rgb + [0]], [0.6, 0.3], 1, 0, "", "", _ring];
    _ring setDropInterval ((_life / _puffs) / _budget);
    _rings pushBack _ring;
};

// Dark condensation core down the middle of the rope.
private _core = "#particlesource" createVehicleLocal _pos;
_core setParticleCircle [0, [0, 0, 0]];
_core setParticleRandom [1, [_size * 0.02, _size * 0.02, 60], [0.5, 0.5, 4], 2, 2, [0, 0, 0, 0.05], 0, 0];
_core setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 7, 48, 1], "", "Billboard", 1, 6, [0, 0, 60], [0, 0, 14], 2, 7.9, 7.9, 0.1, [_size * 0.08, _size * 0.12], [[0.08, 0.08, 0.09, 0], [0.1, 0.1, 0.11, 0.7], [0.12, 0.12, 0.13, 0]], [0.5], 1, 0, "", "", _core];
_core setDropInterval (0.08 / _budget);
_rings pushBack _core;

// Wall cloud spreading out at the top of the funnel.
private _cap = "#particlesource" createVehicleLocal _pos;
_cap setParticleCircle [_size * 1.2, [6, 6, 0]];
_cap setParticleRandom [3, [_size * 0.4, _size * 0.4, 20], [2, 2, 0.5], 1, 0.4, [0, 0, 0, 0.1], 0, 0];
_cap setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 12, [0, 0, 400], [0, 0, 0], 1, 10, 7.85, 0.01, [60, 110], [[0.13, 0.13, 0.15, 0], [0.16, 0.16, 0.18, 0.6], [0.18, 0.18, 0.2, 0]], [0.3], 1, 0, "", "", _cap];
_cap setDropInterval (0.06 / _budget);

// Dust skirt hugging the ground around the foot.
private _skirt = "#particlesource" createVehicleLocal _pos;
_skirt setParticleCircle [_size * 0.25, [22, 22, 0]];
_skirt setParticleRandom [1, [_size * 0.1, _size * 0.1, 1], [3, 3, 3], 3, 0.5, [0, 0, 0, 0.1], 0, 0];
_skirt setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 9, 0], "", "Billboard", 1, 3.5, [0, 0, 2], [0, 0, 6], 3, 10, 7.6, 0.02, [10, 25], [[0.42, 0.37, 0.3, 0], [0.45, 0.4, 0.33, 0.5], [0.5, 0.45, 0.38, 0]], [0.6], 1, 0, "", "", _skirt];
_skirt setDropInterval (0.02 / _budget);

// Debris whipped up and around the foot.
private _debris = "#particlesource" createVehicleLocal _pos;
_debris setParticleCircle [_size * 0.15, [26, 26, 0]];
_debris setParticleRandom [1.5, [_size * 0.08, _size * 0.08, 2], [6, 6, 12], 6, 0.3, [0, 0, 0, 0], 1, 0];
_debris setParticleParams [["\A3\data_f\ParticleEffects\Universal\TreePart.p3d", 1, 0, 1], "", "SpaceObject", 1, 6, [0, 0, 3], [0, 0, 25], 4, 30, 7, 0.1, [0.8, 1.2], [[0.3, 0.25, 0.2, 1], [0.3, 0.25, 0.2, 1]], [1], 1, 0, "", "", _debris, 0, true, 0.5];
_debris setDropInterval (0.05 / _budget);

// Wind roar from a helper that rides along with the funnel.
private _voice = "Land_HelipadEmpty_F" createVehicleLocal _pos;
_voice setPosATL (_pos vectorAdd [0, 0, 5]);

private _emitters = _rings + [_cap, _skirt, _debris];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_center", "_radius", "_speed", "_seed", "_emitters", "_voice", "_nextSound", "_nextShake"];

    if (isNull _anchor) exitWith {
        {deleteVehicle _x} forEach _emitters;
        deleteVehicle _voice;
        DBG("tornado local teardown");
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _pos = [_center, _radius, _speed, _seed] call FUNC(tornadoPos);
    {_x setPosATL _pos} forEach _emitters;
    if (diag_tickTime > (_voice getVariable [QGVAR(logAt), 0])) then {
        _voice setVariable [QGVAR(logAt), diag_tickTime + 10];
        DBG(FORMAT_3("tornado at %1 (%2 m from the storm centre, speed %3 m/s)",mapGridPosition _pos,round (_pos distance2D _center),_speed));
    };
    _voice setPosATL (_pos vectorAdd [0, 0, 5]);

    if (CBA_missionTime >= _nextSound) then {
        _voice say3D [QGVAR(tornadoWind), 1500];
        _args set [7, CBA_missionTime + 58];
    };

    private _distance = player distance2D _pos;
    if (_distance < 400 && CBA_missionTime >= _nextShake) then {
        enableCamShake true;
        addCamShake [linearConversion [0, 400, _distance, 4, 0.3, true], 2.5, 15];
        _args set [8, CBA_missionTime + 2];
    };
}, 0, [_anchor, _center, _radius, _speed, _seed, _emitters, _voice, 0, 0]] call CBA_fnc_addPerFrameHandler;
