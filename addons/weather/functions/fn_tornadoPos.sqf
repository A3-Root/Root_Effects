#include "..\script_component.hpp"

/*
 * Author: Root
 * Where a tornado is at a given mission time. The path is a seeded wander inside
 * the storm radius computed from CBA_missionTime, so the server and every client
 * work out the same spot on their own without syncing a moving object.
 *
 * Arguments:
 * 0: Storm center ATL <ARRAY>
 * 1: Storm radius in meters <NUMBER>
 * 2: Travel speed in m/s <NUMBER>
 * 3: Path seed <NUMBER>
 * 4: Mission time to evaluate (default: now) <NUMBER>
 *
 * Return Value:
 * Tornado ground position ATL <ARRAY>
 *
 * Example:
 * [getPosATL _anchor, 300, 8, 1234] call root_effects_weather_fnc_tornadoPos
 */

params [["_center", [0, 0, 0], [[]], 3], ["_radius", 300, [0]], ["_speed", 8, [0]], ["_seed", 0, [0]], ["_time", CBA_missionTime, [0]]];

private _reach = (_radius * 0.8) max 30;
// Angular rate (deg/s) that moves the funnel at roughly the requested speed.
private _rate = (_speed / _reach) * 57.2958;
private _phaseA = (_seed random 1) * 360;
private _phaseB = ((_seed + 1) random 1) * 360;
private _phaseC = ((_seed + 2) random 1) * 360;

private _offsetX = _reach * (0.7 * sin (_time * _rate + _phaseA) + 0.3 * sin (_time * _rate * 2.3 + _phaseC));
private _offsetY = _reach * (0.7 * cos (_time * _rate * 0.8 + _phaseB) + 0.3 * cos (_time * _rate * 1.7 + _phaseA));

private _pos = _center vectorAdd [_offsetX, _offsetY, 0];
_pos set [2, 0];
_pos
