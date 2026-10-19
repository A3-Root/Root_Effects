#include "..\script_component.hpp"

/*
 * Author: Root
 * Distance from a position to the edge of an active EMP field: positive outside,
 * negative inside. 1e9 while the field counts down, ends or does not exist.
 *
 * Arguments:
 * 0: Position ASL <ARRAY>
 * 1: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 *
 * Return Value:
 * Distance in meters <NUMBER>
 *
 * Example:
 * [getPosASL player, _entry] call root_effects_emp_fnc_empBoundaryDist
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_entry", [], [[]]]];
_entry params [["_anchor", objNull], ["_cfg", createHashMap], "", ["_detTime", 0]];

if (isNull _anchor || CBA_missionTime < _detTime || {_anchor getVariable [QGVAR(ending), false]}) exitWith {1e9};

private _center = getPosASL _anchor;
private _radius = _cfg get "radius";
private _altitude = _cfg get "altitude";

if (_altitude < 0) exitWith {(_pos distance2D _center) - _radius};

([_radius, _altitude] call FUNC(empCap)) params ["_sphere", "_offset"];
(_pos distance (_center vectorAdd [0, 0, _offset])) - _sphere
