#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the acid rain. Reads the module attributes
 * placed in the editor and starts acid rain around the module position when
 * the mission begins.
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
 * [_logic, [], true] call root_effects_weather_fnc_moduleAcidRain3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_ACIDRAIN_RADIUS", 500];
private _tint = _logic getVariable ["ROOT_ACIDRAIN_TINT", 0.5];
private _damage = _logic getVariable ["ROOT_ACIDRAIN_DAMAGE", true];
private _damagePerTick = _logic getVariable ["ROOT_ACIDRAIN_DPS", 0.05];
private _tick = _logic getVariable ["ROOT_ACIDRAIN_TICK", 5];

deleteVehicle _logic;

[_pos, _radius, _tint, _damage, _damagePerTick, _tick] call FUNC(acidRainStart);
