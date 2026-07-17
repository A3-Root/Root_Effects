#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the carpet bombing strike. Reads the module
 * attributes placed in the editor and runs the bombing run over the module
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
 * [_logic, [], true] call root_effects_strikes_fnc_moduleCarpetStrike3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _planeClass = _logic getVariable ["ROOT_CARPET_PLANE", "B_Plane_CAS_01_dynamicLoadout_F"];
private _planeCount = _logic getVariable ["ROOT_CARPET_PLANES", 1];
private _bombClass = _logic getVariable ["ROOT_CARPET_BOMB", "Bo_Mk82"];
private _heading = _logic getVariable ["ROOT_CARPET_HEADING", 0];
private _bombCount = _logic getVariable ["ROOT_CARPET_COUNT", 50];
private _length = _logic getVariable ["ROOT_CARPET_LENGTH", 150];
private _dropDelay = _logic getVariable ["ROOT_CARPET_DELAY", 35];

deleteVehicle _logic;

[_pos, _planeClass, _planeCount, _bombClass, _heading, _bombCount, _length, _dropDelay] call FUNC(carpetStart);
