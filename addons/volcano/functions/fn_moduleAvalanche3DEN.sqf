#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the scree avalanche. Reads the module attributes
 * placed in the editor and starts the slide at the module position when the
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
 * [_logic, [], true] call root_effects_volcano_fnc_moduleAvalanche3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _downhill = _logic getVariable ["ROOT_AVALANCHE_DOWNHILL", true];
private _heading = _logic getVariable ["ROOT_AVALANCHE_HEADING", 0];
private _length = _logic getVariable ["ROOT_AVALANCHE_LENGTH", 200];
private _duration = _logic getVariable ["ROOT_AVALANCHE_DURATION", 25];
private _lethal = _logic getVariable ["ROOT_AVALANCHE_LETHAL", true];
private _objects = _logic getVariable ["ROOT_AVALANCHE_OBJECTS", ""];

deleteVehicle _logic;

// A negative heading tells the slide to work the slope out for itself.
if (_downhill) then {
    _heading = -1;
};

[_pos, _heading, _length, _duration, _lethal, _objects] call FUNC(avalancheStart);
