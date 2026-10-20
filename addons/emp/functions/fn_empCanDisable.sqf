#include "..\script_component.hpp"

/*
 * Author: Root
 * Checks whether a unit can shut down the EMP field on an object: within interactDistance m of its bounds,
 * field still running, countdown abort allowed (before detonation) and the
 * required item carried.
 *
 * Arguments:
 * 0: Object the field sits on <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Can disable <BOOL>
 *
 * Example:
 * [terminal_1, player] call root_effects_emp_fnc_empCanDisable
 */

params [["_object", objNull, [objNull]], ["_unit", objNull, [objNull]]];

private _anchor = _object getVariable [QGVAR(anchor), objNull];
if (isNull _anchor || {!alive _unit} || {_anchor getVariable [QGVAR(ending), false]}) exitWith {false};

private _entry = GVAR(fields) select {(_x select 0) isEqualTo _anchor};
if (_entry isEqualTo []) exitWith {false};
(_entry select 0) params ["", "_cfg", "", "_detTime"];

if ((_unit distance _object) > ((boundingBoxReal _object) select 2) / 2 + (_cfg getOrDefault ["interactDistance", 5])) exitWith {false};

if (CBA_missionTime < _detTime && {!(_cfg get "abortCountdown")}) exitWith {false};

private _item = _cfg get "requiredItem";
_item isEqualTo "" || {_item in ((items _unit) + (assignedItems _unit))}
