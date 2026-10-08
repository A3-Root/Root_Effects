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

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","Aurora",mapGridPosition _logic,allVariables _logic));

private _pos = getPosATL _logic;
private _altitude = _logic getVariable ["ROOT_AURORA_ALTITUDE", 500];
private _shape = _logic getVariable ["ROOT_AURORA_SHAPE", 0];
private _fadeIn = _logic getVariable ["ROOT_AURORA_FADEIN", 20];
private _fadeOut = _logic getVariable ["ROOT_AURORA_FADEOUT", 20];
private _lifetime = _logic getVariable ["ROOT_AURORA_LIFETIME", 180];
private _density = _logic getVariable ["ROOT_AURORA_DENSITY", 0.5];
private _fixed = _logic getVariable ["ROOT_AURORA_FIXED", false];
private _sizeScale = _logic getVariable ["ROOT_AURORA_SIZE", 1];
private _lengthScale = _logic getVariable ["ROOT_AURORA_LENGTH", 1];
private _switchInterval = _logic getVariable ["ROOT_AURORA_SWITCH", 0];

deleteVehicle _logic;

[_pos, _altitude, _shape, _fadeIn, _fadeOut, _lifetime, _density, _fixed, _sizeScale, _lengthScale, _switchInterval] call FUNC(auroraStart);
