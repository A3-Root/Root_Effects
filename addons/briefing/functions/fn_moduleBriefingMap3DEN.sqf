#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the live briefing map. Reads the module
 * attributes placed in the editor and places a map board with a live map
 * feed at the module position when the mission begins.
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
 * [_logic, [], true] call root_effects_briefing_fnc_moduleBriefingMap3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _dir = getDir _logic;
private _zoom = _logic getVariable ["ROOT_BMAP_ZOOM", 0.1];
private _activationDistance = _logic getVariable ["ROOT_BMAP_ACTDIST", 50];

deleteVehicle _logic;

[_pos, _dir, "", _zoom, _activationDistance] call FUNC(briefingMapStart);
