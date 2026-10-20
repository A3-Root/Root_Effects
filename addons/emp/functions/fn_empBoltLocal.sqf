#include "..\script_component.hpp"

/*
 * Author: Root
 * Client lightning burst with static burst particles: a local
 * particle source throwing self-lit blesk1 bolts that grow from the point, for
 * the given time. Size 1 is a bolt about 122 m tall.
 *
 * Arguments:
 * 0: Position AGL <ARRAY>
 * 1: Duration in s <NUMBER> (optional, default 0.3)
 * 2: Bolt size <NUMBER> (optional, default 0.25)
 * 3: Bolt size variance <NUMBER> (optional, default 1.5)
 * 4: Drop interval in s <NUMBER> (optional, default 0.025)
 * 5: Bolt lifetime in s <NUMBER> (optional, default 0.75)
 *
 * Return Value:
 * None
 *
 * Example:
 * [ASLToAGL getPosASL player, 1.25] call root_effects_emp_fnc_empBoltLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_duration", 0.3, [0]], ["_size", 0.25, [0]], ["_sizeVar", 1.5, [0]], ["_interval", 0.025, [0]], ["_life", 0.75, [0]]];

if (!hasInterface) exitWith {};

private _source = "#particlesource" createVehicleLocal _pos;
_source setPosASL (AGLToASL _pos);
_source setParticleCircle [0, [50, 50, 50]];
_source setParticleRandom [_life / 3, [0, 0, 0], [0, 0, 0], 0.25, _sizeVar, [0, 0, 0, 1], 1, 0];
_source setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, _life, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0, _size],
    [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _source, 0, false, -1, [[100, 100, 1000, 1], [0, 0, 1, 0.01]]];
_source setDropInterval _interval;
[{deleteVehicle _this}, _source, _duration] call CBA_fnc_waitAndExecute;
