#include "..\script_component.hpp"

/*
 * Author: Root
 * Sphere that forms the EMP dome: a cap with the given ground radius and height.
 * Altitude -1 gives a hemisphere.
 *
 * Arguments:
 * 0: Ground radius in meters <NUMBER>
 * 1: Dome height in meters, -1 hemisphere <NUMBER>
 *
 * Return Value:
 * [sphere radius, sphere center height relative to the ground center] <ARRAY>
 *
 * Example:
 * [300, 100] call root_effects_emp_fnc_empCap
 */

params [["_radius", 300, [0]], ["_altitude", -1, [0]]];

if (_altitude <= 0) exitWith {[_radius, 0]};

private _sphere = (_radius ^ 2 + _altitude ^ 2) / (2 * _altitude);
[_sphere, _altitude - _sphere]
