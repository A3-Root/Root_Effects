#include "..\script_component.hpp"

/*
 * Author: Root
 * Public API. Checks whether a unit, vehicle or position is inside an active EMP
 * field the shockwave has already reached. Works on every machine.
 *
 * Arguments:
 * 0: Object or position ASL <OBJECT, ARRAY>
 * 1: Only this field anchor <OBJECT> (optional, default objNull: any field)
 *
 * Return Value:
 * Inside <BOOL>
 *
 * Example:
 * [player] call root_effects_emp_fnc_isInside
 */

params [["_target", objNull, [objNull, []]], ["_only", objNull, [objNull]]];

private _pos = if (_target isEqualType objNull) then {getPosASL _target} else {_target};

(GVAR(fields) findIf {
    (isNull _only || {(_x select 0) isEqualTo _only}) && {[_pos, _x] call FUNC(empInZone)}
}) != -1
