#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the sweeping searchlight. Reads the module
 * attributes placed in the editor and starts a searchlight instance at the
 * module position when the mission begins.
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
 * [_logic, [], true] call root_effects_battlescripts_fnc_moduleSearchlight3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _alarm = _logic getVariable ["ROOT_SEARCHLIGHT_ALARM", false];
private _attach = _logic getVariable ["ROOT_SEARCHLIGHT_ATTACH", false];
private _aiSearch = _logic getVariable ["ROOT_SEARCHLIGHT_AISEARCH", true];

deleteVehicle _logic;

[_pos, _alarm, _attach, _aiSearch] call FUNC(searchlightStart);
