#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the water tint. Reads the module attributes
 * placed in the editor and starts the tint zone around the module position
 * when the mission begins.
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
 * [_logic, [], true] call root_effects_weather_fnc_moduleWaterTint3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_WATERTINT_RADIUS", 500];
private _colorIndex = _logic getVariable ["ROOT_WATERTINT_COLOR", 0];
private _strength = _logic getVariable ["ROOT_WATERTINT_STRENGTH", 0.6];

deleteVehicle _logic;

[_pos, _radius, _colorIndex, _strength] call FUNC(waterTintStart);
