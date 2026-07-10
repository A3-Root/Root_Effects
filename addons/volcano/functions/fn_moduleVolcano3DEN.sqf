#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the volcano effect. Reads the module attributes
 * placed in the editor and starts a volcano instance at the module position
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
 * [_logic, [], true] call root_effects_volcano_fnc_moduleVolcano3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_VOLCANO_RADIUS", 120];
private _eruption = _logic getVariable ["ROOT_VOLCANO_ERUPTION", false];
private _delay = _logic getVariable ["ROOT_VOLCANO_DELAY", 300];
private _craterLava = _logic getVariable ["ROOT_VOLCANO_CRATERLAVA", false];
private _lightning = _logic getVariable ["ROOT_VOLCANO_LIGHTNING", false];
private _lavaFlow = _logic getVariable ["ROOT_VOLCANO_LAVAFLOW", false];
private _lethal = _logic getVariable ["ROOT_VOLCANO_LETHAL", true];
private _gearText = _logic getVariable ["ROOT_VOLCANO_GEAR", ""];

deleteVehicle _logic;

if (!_eruption) then {
    _delay = 0;
};

[_pos, _radius, _delay, _craterLava, _lightning, _lavaFlow, _lethal, _gearText] call FUNC(volcanoStart);
