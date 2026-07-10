#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the ambient tracer fire. Reads the module
 * attributes placed in the editor and starts a tracer source at the module
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
 * [_logic, [], true] call root_effects_battlescripts_fnc_moduleTracerFire3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _activationDistance = _logic getVariable ["ROOT_TRACERS_ACTDIST", 150];
private _red = _logic getVariable ["ROOT_TRACERS_RED", 1];
private _green = _logic getVariable ["ROOT_TRACERS_GREEN", 1];
private _blue = _logic getVariable ["ROOT_TRACERS_BLUE", 1];

deleteVehicle _logic;

[_pos, _activationDistance, [_red, _green, _blue]] call FUNC(tracersStart);
