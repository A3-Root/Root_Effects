#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the aurora borealis. Reads the module
 * attributes placed in the editor and starts an aurora above the module
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
 * [_logic, [], true] call root_effects_ambientsfx_fnc_moduleAurora3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _altitude = _logic getVariable ["ROOT_AURORA_ALTITUDE", 500];

deleteVehicle _logic;

[_pos, _altitude] call FUNC(auroraStart);
