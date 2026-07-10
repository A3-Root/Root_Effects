#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the ambient missile launcher. Reads the module
 * attributes placed in the editor and starts a launcher instance at the
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
 * [_logic, [], true] call root_effects_battlescripts_fnc_moduleMissileLauncher3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _safeDistance = _logic getVariable ["ROOT_MISSILES_SAFEDIST", 25];
private _launchDelay = _logic getVariable ["ROOT_MISSILES_DELAY", 10];

deleteVehicle _logic;

[_pos, _safeDistance, _launchDelay] call FUNC(missilesStart);
