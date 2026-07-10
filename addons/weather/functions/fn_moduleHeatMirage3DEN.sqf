#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the heat mirage. Reads the module attributes
 * placed in the editor and starts a shimmering heat haze zone around the
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
 * [_logic, [], true] call root_effects_weather_fnc_moduleHeatMirage3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_MIRAGE_RADIUS", 200];
private _intensity = _logic getVariable ["ROOT_MIRAGE_INTENSITY", 0.5];

deleteVehicle _logic;

[_pos, _radius, _intensity] call FUNC(mirageStart);
