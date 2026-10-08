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

DBG(FORMAT_1("moduleRupture3DEN called with %1",_this));

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","Rupture",mapGridPosition _logic,allVariables _logic));

private _pos = getPosATL _logic;
private _altitude = _logic getVariable ["ROOT_RUPTURE_ALTITUDE", 500];
private _shape = _logic getVariable ["ROOT_RUPTURE_SHAPE", 0];
private _fadeIn = _logic getVariable ["ROOT_RUPTURE_FADEIN", 20];
private _fadeOut = _logic getVariable ["ROOT_RUPTURE_FADEOUT", 20];
private _lifetime = _logic getVariable ["ROOT_RUPTURE_LIFETIME", 180];
private _density = _logic getVariable ["ROOT_RUPTURE_DENSITY", 0.5];
private _fixed = _logic getVariable ["ROOT_RUPTURE_FIXED", false];
private _sizeScale = _logic getVariable ["ROOT_RUPTURE_SIZE", 1];
private _lengthScale = _logic getVariable ["ROOT_RUPTURE_LENGTH", 1];
private _switchInterval = _logic getVariable ["ROOT_RUPTURE_SWITCH", 0];
private _moveSpeed = _logic getVariable ["ROOT_RUPTURE_MOVESPEED", 0];
private _moveMode = _logic getVariable ["ROOT_RUPTURE_MOVEMODE", 0];

deleteVehicle _logic;

[_pos, _altitude, _shape, _fadeIn, _fadeOut, _lifetime, _density, _fixed, _sizeScale, _lengthScale, _switchInterval, _moveSpeed, _moveMode] call FUNC(ruptureStart);
