#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for a feed. Reads the editor attributes and starts a
 * feed at the module position once the mission begins, spawning its own screen
 * and (for a drone feed) drone.
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
 * [_logic, [], true] call root_effects_dronefeed_fnc_moduleCreateFeed3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _droneClass = _logic getVariable ["ROOT_DRONEFEED_DRONECLASS", "B_UAV_02_dynamicLoadout_F"];
private _droneAlt = _logic getVariable ["ROOT_DRONEFEED_DRONEALT", 500];
private _screenClass = _logic getVariable ["ROOT_DRONEFEED_SCREENCLASS", "Land_TripodScreen_01_large_F"];
private _textureId = _logic getVariable ["ROOT_DRONEFEED_TEXID", 0];
private _satellite = _logic getVariable ["ROOT_DRONEFEED_SATELLITE", false];
private _satAlt = _logic getVariable ["ROOT_DRONEFEED_SATALT", 1000];
private _radius = _logic getVariable ["ROOT_DRONEFEED_RADIUS", 100];
private _view = _logic getVariable ["ROOT_DRONEFEED_VIEW", VIEW_GUNNER];
private _proxy = _logic getVariable ["ROOT_DRONEFEED_PROXY", false];
private _proxyAlt = _logic getVariable ["ROOT_DRONEFEED_PROXYALT", 1200];

deleteVehicle _logic;

private _mode = [FEED_MODE_DRONE, FEED_MODE_SATELLITE] select _satellite;
private _render = [RENDER_MODE_ACCURATE, RENDER_MODE_PROXY] select _proxy;

private _config = [_pos, _mode, "", _screenClass, "", _droneClass, _droneAlt, _textureId, _radius, _render, _view, _satAlt, _proxyAlt, ""];
[_config] call FUNC(serverCreateFeed);
