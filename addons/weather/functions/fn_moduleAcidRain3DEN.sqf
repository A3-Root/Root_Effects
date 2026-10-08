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

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","AcidRain",mapGridPosition _logic,allVariables _logic));

private _pos = getPosATL _logic;
private _radius = _logic getVariable ["ROOT_ACIDRAIN_RADIUS", 500];
private _tint = _logic getVariable ["ROOT_ACIDRAIN_TINT", 0.5];
private _damage = _logic getVariable ["ROOT_ACIDRAIN_DAMAGE", true];
private _damagePerTick = _logic getVariable ["ROOT_ACIDRAIN_DPS", 0.05];
private _tick = _logic getVariable ["ROOT_ACIDRAIN_TICK", 5];
private _intensity = _logic getVariable ["ROOT_ACIDRAIN_INTENSITY", 0.7];
private _weatherRain = _logic getVariable ["ROOT_ACIDRAIN_WEATHER", true];
private _vehicleRate = _logic getVariable ["ROOT_ACIDRAIN_VEHRATE", 0.02];
private _buildingRate = _logic getVariable ["ROOT_ACIDRAIN_BLDGRATE", 0.01];
private _buildingCap = _logic getVariable ["ROOT_ACIDRAIN_BLDGCAP", 0.9];
private _safeGear = _logic getVariable ["ROOT_ACIDRAIN_SAFEGEAR", ""];
private _safeVehicles = _logic getVariable ["ROOT_ACIDRAIN_SAFEVEH", ""];
private _safeBuildings = _logic getVariable ["ROOT_ACIDRAIN_SAFEBLDG", ""];
private _safeAreas = _logic getVariable ["ROOT_ACIDRAIN_SAFEAREAS", ""];

deleteVehicle _logic;

DBG(FORMAT_3("acid rain 3DEN module at %1 (radius %2, safe zones %3)",mapGridPosition _pos,_radius,_safeAreas));
[_pos, _radius, _tint, _damage, _damagePerTick, _tick, _intensity, _weatherRain, _vehicleRate, _buildingRate, _buildingCap, _safeGear, _safeVehicles, _safeBuildings, _safeAreas] call FUNC(acidRainStart);
