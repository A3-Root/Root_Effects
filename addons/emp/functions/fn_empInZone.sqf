#include "..\script_component.hpp"

/*
 * Author: Root
 * Checks a position against one EMP field. The field is a spherical cap: radius
 * on the ground, dome height on top (no height limit with altitude -1). With
 * wave check on, the position only counts once the shockwave reached it.
 *
 * Arguments:
 * 0: Position ASL <ARRAY>
 * 1: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 * 2: Require the shockwave to have passed <BOOL> (optional, default true)
 *
 * Return Value:
 * Inside <BOOL>
 *
 * Example:
 * [getPosASL player, _entry] call root_effects_emp_fnc_empInZone
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_entry", [], [[]]], ["_wave", true, [true]]];
_entry params [["_anchor", objNull], ["_cfg", createHashMap], "", ["_detTime", 0]];

if (isNull _anchor) exitWith {false};
if (_anchor getVariable [QGVAR(ending), false]) exitWith {false};
if (CBA_missionTime < _detTime) exitWith {false};

private _center = getPosASL _anchor;
private _radius = _cfg get "radius";
private _altitude = _cfg get "altitude";

if ((_pos distance2D _center) > _radius && {_altitude < 0 || _altitude <= _radius}) exitWith {false};

private _inside = if (_altitude < 0) then {
    (_pos distance2D _center) <= _radius
} else {
    ([_radius, _altitude] call FUNC(empCap)) params ["_sphere", "_offset"];
    (_pos distance (_center vectorAdd [0, 0, _offset])) <= _sphere
};
if (!_inside || !_wave) exitWith {_inside};

private _speed = _cfg get "shockSpeed";
_speed <= 0 || {CBA_missionTime >= _detTime + (_pos distance _center) / _speed}
