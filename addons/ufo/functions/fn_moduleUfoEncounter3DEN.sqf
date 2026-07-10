#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the UFO encounter effect. Reads the module
 * attributes placed in the editor and starts random UFO sightings when the
 * mission begins.
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
 * [_logic, [], true] call root_effects_ufo_fnc_moduleUfoEncounter3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _frequency = _logic getVariable ["ROOT_UFO_ENCOUNTERFREQ", 30];

deleteVehicle _logic;

[_pos, _frequency] call FUNC(encounterStart);
