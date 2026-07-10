#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the lightning storm. Reads the module
 * attributes placed in the editor and starts a storm around the module
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
 * [_logic, [], true] call root_effects_weather_fnc_moduleLightningStorm3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_LIGHTNING_RADIUS", 300];
private _duration = _logic getVariable ["ROOT_LIGHTNING_DURATION", 300];
private _minInterval = _logic getVariable ["ROOT_LIGHTNING_MININT", 5];
private _maxInterval = _logic getVariable ["ROOT_LIGHTNING_MAXINT", 20];
private _damage = _logic getVariable ["ROOT_LIGHTNING_DAMAGE", false];

deleteVehicle _logic;

[_pos, _radius, _duration, _minInterval, _maxInterval, _damage] call FUNC(lightningStart);
