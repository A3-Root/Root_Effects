#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the singularity strike. Reads the module
 * attributes placed in the editor and starts the anomaly at the module
 * position when the mission begins.
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
 * [_logic, [], true] call root_effects_strikes_fnc_moduleSingularity3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_SINGULARITY_RADIUS", 120];
private _chargeTime = _logic getVariable ["ROOT_SINGULARITY_CHARGE", 6];
private _lethal = _logic getVariable ["ROOT_SINGULARITY_LETHAL", true];

deleteVehicle _logic;

[_pos, _radius, _chargeTime, _lethal] call FUNC(singularityStart);
