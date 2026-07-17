#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the orbital laser strike. Reads the module
 * attributes placed in the editor and fires the laser at the module position
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
 * [_logic, [], true] call root_effects_strikes_fnc_moduleLaserStrike3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _chargeTime = _logic getVariable ["ROOT_LASER_CHARGE", 5];
private _beamTime = _logic getVariable ["ROOT_LASER_BEAM", 3];
private _color = [
    _logic getVariable ["ROOT_LASER_RED", 1],
    _logic getVariable ["ROOT_LASER_GREEN", 0.2],
    _logic getVariable ["ROOT_LASER_BLUE", 0.2]
];
private _damage = _logic getVariable ["ROOT_LASER_DAMAGE", true];
private _damageRadius = _logic getVariable ["ROOT_LASER_DMGRADIUS", 30];

deleteVehicle _logic;

[_pos, _chargeTime, _beamTime, _color, _damage, _damageRadius] call FUNC(laserStart);
