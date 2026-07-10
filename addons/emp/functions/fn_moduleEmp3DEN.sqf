#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the EMP pulse. Reads the module attributes
 * placed in the editor and detonates the pulse at the module position when
 * the mission begins.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Module activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call root_effects_emp_fnc_moduleEmp3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_EMP_RADIUS", 300];
private _duration = _logic getVariable ["ROOT_EMP_DURATION", 20];
private _killEngines = _logic getVariable ["ROOT_EMP_KILLENGINES", true];
private _fuelDrain = _logic getVariable ["ROOT_EMP_FUELDRAIN", 0];
private _hud = _logic getVariable ["ROOT_EMP_HUD", true];

deleteVehicle _logic;

[_pos, _radius, _duration, _killEngines, _fuelDrain, _hud] call FUNC(empStart);
