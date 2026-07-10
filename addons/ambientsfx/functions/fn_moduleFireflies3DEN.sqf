#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the ambient fireflies. Reads the module
 * attributes placed in the editor and starts a firefly swarm at the module
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
 * [_logic, [], true] call root_effects_ambientsfx_fnc_moduleFireflies3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _altitude = _logic getVariable ["ROOT_FIREFLIES_ALTITUDE", 1];
private _activationDistance = _logic getVariable ["ROOT_FIREFLIES_ACTDIST", 100];
private _frogs = _logic getVariable ["ROOT_FIREFLIES_FROGS", true];

deleteVehicle _logic;

[_pos, _altitude, _activationDistance, _frogs] call FUNC(firefliesStart);
