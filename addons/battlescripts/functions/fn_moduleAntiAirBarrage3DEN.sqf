#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the anti air barrage. Reads the module
 * attributes placed in the editor and starts a barrage instance at the
 * module position when the mission begins.
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
 * [_logic, [], true] call root_effects_battlescripts_fnc_moduleAntiAirBarrage3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_AAA_RADIUS", 500];
private _altitude = _logic getVariable ["ROOT_AAA_ALTITUDE", 150];
private _lethal = _logic getVariable ["ROOT_AAA_LETHAL", true];
private _damageAir = _logic getVariable ["ROOT_AAA_DMGAIR", 0.05];
private _damageInf = _logic getVariable ["ROOT_AAA_DMGINF", 0.2];
private _burstDelay = _logic getVariable ["ROOT_AAA_DELAY", 1];
private _smokeOnly = _logic getVariable ["ROOT_AAA_SMOKEONLY", false];
private _spread = _logic getVariable ["ROOT_AAA_SPREAD", 1];
private _fireRate = _logic getVariable ["ROOT_AAA_FIRERATE", 1];

deleteVehicle _logic;

[_pos, _radius, _altitude, _lethal, _damageAir, _damageInf, _burstDelay, _smokeOnly, _spread, _fireRate] call FUNC(aaaStart);
