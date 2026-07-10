#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the floating objects gag. Reads the module
 * attributes placed in the editor and animates the nearest object to the
 * module (or every synchronized object) when the mission begins.
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
 * [_logic, [], true] call root_effects_floatingobjects_fnc_moduleFloatingObjects3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _elevation = _logic getVariable ["ROOT_FLOAT_ELEVATION", 5];
private _allowDamage = _logic getVariable ["ROOT_FLOAT_DAMAGE", true];
private _allowSimulation = _logic getVariable ["ROOT_FLOAT_SIMULATION", false];
private _slideVel = _logic getVariable ["ROOT_FLOAT_SLIDEVEL", 0];
private _slideDist = _logic getVariable ["ROOT_FLOAT_SLIDEDIST", 0];
private _bounceSpeed = _logic getVariable ["ROOT_FLOAT_BOUNCESPEED", 0];
private _bounceAlt = _logic getVariable ["ROOT_FLOAT_BOUNCEALT", 0];
private _rotVel = _logic getVariable ["ROOT_FLOAT_ROTVEL", 1];
private _rotCw = _logic getVariable ["ROOT_FLOAT_ROTCW", true];
private _rollVel = _logic getVariable ["ROOT_FLOAT_ROLLVEL", 0];
private _orbitRadius = _logic getVariable ["ROOT_FLOAT_ORBITRADIUS", 0];
private _orbitSpeed = _logic getVariable ["ROOT_FLOAT_ORBITSPEED", 0.1];
private _orbitCw = _logic getVariable ["ROOT_FLOAT_ORBITCW", true];
private _actDist = _logic getVariable ["ROOT_FLOAT_ACTDIST", 9999];

// Animate every synchronized object, or the nearest object when nothing is
// synchronized in the editor.
private _targets = _units select {!isNull _x};
if (_targets isEqualTo []) then {
    private _nearest = nearestObjects [getPosATL _logic, [], 10] select {!(_x isKindOf "Logic")};
    if (_nearest isNotEqualTo []) then {
        _targets pushBack (_nearest select 0);
    };
};

deleteVehicle _logic;

{
    [_x, _elevation, _allowDamage, _allowSimulation, [_slideVel, _slideDist], [_bounceSpeed, _bounceAlt], [_rotVel, _rotCw], _rollVel, [_orbitRadius, _orbitSpeed, _orbitCw], _actDist] call FUNC(floatingStart);
} forEach _targets;
