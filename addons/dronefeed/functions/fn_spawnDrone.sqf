#include "..\script_component.hpp"

/*
 * Author: Root
 * Spawns a UAV of the requested class on the server, crews it, sends it to
 * loiter over the target area at the given altitude and returns it. Used when a
 * feed is created without an existing drone to point at.
 *
 * Arguments:
 * 0: Drone class name <STRING>
 * 1: Center position ATL to loiter over <ARRAY>
 * 2: Loiter altitude in meters <NUMBER>
 *
 * Return Value:
 * Spawned drone, objNull on failure <OBJECT>
 *
 * Example:
 * ["B_UAV_02_dynamicLoadout_F", [1000, 2000, 0], 500] call root_effects_dronefeed_fnc_spawnDrone
 */

params [["_class", "", [""]], ["_pos", [0, 0, 0], [[]], 3], ["_alt", 500, [0]]];

if (!isServer) exitWith {objNull};
if (!isClass (configFile >> "CfgVehicles" >> _class)) exitWith {objNull};

private _spawnPos = [_pos select 0, _pos select 1, _alt];
private _drone = createVehicle [_class, _spawnPos, [], 0, "FLY"];
_drone setPosATL _spawnPos;
createVehicleCrew _drone;

private _group = group _drone;
_group setBehaviour "CARELESS";
_group setCombatMode "BLUE";
_drone flyInHeight _alt;
_drone setCaptive true;
{
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x setCaptive true;
} forEach crew _drone;

private _wp = _group addWaypoint [_pos, 0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterRadius 500;
_wp setWaypointLoiterType "CIRCLE_L";

_drone
