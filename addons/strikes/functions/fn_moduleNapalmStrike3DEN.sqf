#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the napalm strike. Reads the module attributes
 * placed in the editor and runs the strike over the module position when the
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
 * [_logic, [], true] call root_effects_strikes_fnc_moduleNapalmStrike3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _planeClass = _logic getVariable ["ROOT_NAPALM_PLANE", "B_Plane_CAS_01_dynamicLoadout_F"];
private _heading = _logic getVariable ["ROOT_NAPALM_HEADING", 0];
private _length = _logic getVariable ["ROOT_NAPALM_LENGTH", 150];
private _duration = _logic getVariable ["ROOT_NAPALM_DURATION", 90];
private _damage = _logic getVariable ["ROOT_NAPALM_DAMAGE", true];

deleteVehicle _logic;

[_pos, _planeClass, _heading, _length, _duration, _damage] call FUNC(napalmStart);
