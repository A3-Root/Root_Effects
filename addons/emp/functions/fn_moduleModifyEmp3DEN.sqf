#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module: when activated (by its trigger, or at mission start without one)
 * changes or shuts down an EMP field: the one on the first synced object,
 * otherwise the closest within the search range. Waits briefly for the field
 * to exist.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call root_effects_emp_fnc_moduleModifyEmp3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

DBG(FORMAT_1("moduleModifyEmp3DEN called with %1",_this));

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","ModifyEmp",mapGridPosition _logic,allVariables _logic));

private _pos = getPosATL _logic;
private _range = (_logic getVariable ["ROOT_EMPMOD_RANGE", 3000]) max 10;
private _shutDown = _logic getVariable ["ROOT_EMPMOD_SHUTDOWN", false];
private _synced = (synchronizedObjects _logic) select {!(_x isKindOf "EmptyDetector") && {!(_x isKindOf "Logic")}};
private _object = _synced param [0, objNull];

// Only changed values: -1 keeps radius and dome, -2 keeps linger.
private _settings = [];
private _radius = _logic getVariable ["ROOT_EMPMOD_RADIUS", -1];
if (_radius > 0) then {_settings pushBack ["radius", _radius]};
private _linger = _logic getVariable ["ROOT_EMPMOD_LINGER", -2];
if (_linger > -2) then {_settings pushBack ["linger", _linger]};
private _dome = _logic getVariable ["ROOT_EMPMOD_DOME", -1];
if (_dome >= 0) then {_settings pushBack ["dome", _dome > 0]};
private _extra = _logic getVariable ["ROOT_EMPMOD_SETTINGS", ""];
if (_extra isNotEqualTo "") then {
    private _parsed = parseSimpleArray _extra;
    {
        if (_x isEqualType [] && {count _x == 2} && {(_x select 0) isEqualType ""}) then {
            _settings pushBack _x;
        };
    } forEach _parsed;
};
deleteVehicle _logic;

private _fnc_find = {
    params ["_pos", "_range", "_object"];
    private _anchor = _object getVariable [QGVAR(anchor), objNull];
    if (!isNull _anchor) exitWith {_anchor};
    ((nearestObjects [[_pos select 0, _pos select 1, 0], [ANCHOR_CLASS], _range]) select {
        (_x getVariable [QEGVAR(main,effectKey), ""]) isEqualTo "emp" && {!(_x getVariable [QGVAR(ending), false])}
    }) param [0, objNull]
};

[{
    params ["_pos", "_range", "_object", "", "", "_fnc_find"];
    !isNull ([_pos, _range, _object] call _fnc_find)
}, {
    params ["_pos", "_range", "_object", "_shutDown", "_settings", "_fnc_find"];
    private _anchor = [_pos, _range, _object] call _fnc_find;
    if (_shutDown) exitWith {[_anchor] call FUNC(disable)};
    [_anchor, _settings] call FUNC(modify);
}, [_pos, _range, _object, _shutDown, _settings, _fnc_find], 15, {
    params ["_pos", "_range"];
    DBG(FORMAT_2("EMP modify 3DEN module found no field within %1 m of %2",_range,mapGridPosition _pos));
}] call CBA_fnc_waitUntilAndExecute;
