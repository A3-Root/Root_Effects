#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the artillery barrage. Reads the module
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
 * [_logic, [], true] call root_effects_battlescripts_fnc_moduleArtilleryBarrage3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_ARTY_RADIUS", 500];
private _mode = _logic getVariable ["ROOT_ARTY_MODE", 0];
private _shellClass = _logic getVariable ["ROOT_ARTY_SHELL", "Sh_155mm_AMOS"];
private _fireDelay = _logic getVariable ["ROOT_ARTY_DELAY", 3];

deleteVehicle _logic;

[_pos, _radius, _mode, _shellClass, _fireDelay] call FUNC(artilleryStart);
