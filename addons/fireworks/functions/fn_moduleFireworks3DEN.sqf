#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the fireworks display. Reads the module
 * attributes placed in the editor and starts a display at the module
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
 * [_logic, [], true] call root_effects_fireworks_fnc_moduleFireworks3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _duration = _logic getVariable ["ROOT_FIREWORKS_DURATION", 120];
private _rate = _logic getVariable ["ROOT_FIREWORKS_RATE", 12];
private _radius = _logic getVariable ["ROOT_FIREWORKS_RADIUS", 50];
private _height = _logic getVariable ["ROOT_FIREWORKS_HEIGHT", 150];
private _sounds = _logic getVariable ["ROOT_FIREWORKS_SOUNDS", true];

deleteVehicle _logic;

[_pos, _duration, _rate, _radius, _height, _sounds] call FUNC(fireworksStart);
