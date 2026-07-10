#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the spacetime rupture. Reads the module
 * attributes placed in the editor and starts a rupture above the module
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
 * [_logic, [], true] call root_effects_ambientsfx_fnc_moduleRupture3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _altitude = _logic getVariable ["ROOT_RUPTURE_ALTITUDE", 500];

deleteVehicle _logic;

[_pos, _altitude] call FUNC(ruptureStart);
