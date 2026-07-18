#include "..\script_component.hpp"

/*
 * Author: Root
 * Creates a drone or satellite feed on the server. Spawns a screen and/or drone
 * when the curator did not supply existing ones, starts the effect through the
 * shared framework (so the anchor doubles as the JIP key and the Terminate
 * module can stop it) and publishes the feed's mutable state on the screen
 * object for every client to read.
 *
 * Arguments (single array):
 * 0: Center position ATL <ARRAY>
 * 1: Feed mode, "DRONE" or "SATELLITE" <STRING>
 * 2: Existing screen netId, "" to spawn one <STRING>
 * 3: Screen class to spawn <STRING>
 * 4: Existing drone netId, "" to spawn one <STRING>
 * 5: Drone class to spawn <STRING>
 * 6: Drone spawn altitude <NUMBER>
 * 7: Screen texture index <NUMBER>
 * 8: Proximity radius <NUMBER>
 * 9: Render mode, "ACCURATE" or "PROXY" <STRING>
 * 10: Camera view, "GUNNER"/"DRIVER"/"BOTH" <STRING>
 * 11: Satellite altitude <NUMBER>
 * 12: Proxy altitude <NUMBER>
 * 13: Controller netId, "" for none <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[[1000,2000,0], "DRONE", "", "Land_TripodScreen_01_large_F", "", "B_UAV_02_dynamicLoadout_F", 500, 0, 100, "ACCURATE", "GUNNER", 1000, 1200, ""]] call root_effects_dronefeed_fnc_serverCreateFeed
 */

params [["_config", [], [[]]]];
_config params [
    ["_center", [0, 0, 0], [[]], 3],
    ["_mode", FEED_MODE_DRONE, [""]],
    ["_screenNetId", "", [""]],
    ["_screenClass", "Land_TripodScreen_01_large_F", [""]],
    ["_droneNetId", "", [""]],
    ["_droneClass", "B_UAV_02_dynamicLoadout_F", [""]],
    ["_droneAlt", 500, [0]],
    ["_textureId", 0, [0]],
    ["_radius", 100, [0]],
    ["_renderMode", RENDER_MODE_ACCURATE, [""]],
    ["_view", VIEW_GUNNER, [""]],
    ["_satAlt", 1000, [0]],
    ["_proxyAlt", 1200, [0]],
    ["_controllerNetId", "", [""]]
];

if (!isServer) exitWith {};
if (!(["dronefeed"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (count GVAR(feeds) >= GVAR(maxFeeds)) exitWith {
    DBG("drone feed rejected, feed limit reached");
};

private _spawned = [];

// Resolve or spawn the screen the feed is projected onto.
private _screen = objNull;
if (_screenNetId isNotEqualTo "") then {
    _screen = objectFromNetId _screenNetId;
} else {
    if (isClass (configFile >> "CfgVehicles" >> _screenClass)) then {
        _screen = createVehicle [_screenClass, _center, [], 0, "CAN_COLLIDE"];
        _screen setPosATL _center;
        _screen setDir (getDir _screen);
        _spawned pushBack _screen;
    };
};
if (isNull _screen) exitWith {
    {deleteVehicle _x} forEach _spawned;
    DBG("drone feed rejected, no screen");
};

// Resolve or spawn the drone for a drone feed.
private _drone = objNull;
if (_mode isEqualTo FEED_MODE_DRONE) then {
    if (_droneNetId isNotEqualTo "") then {
        _drone = objectFromNetId _droneNetId;
    } else {
        _drone = [_droneClass, _center, _droneAlt] call FUNC(spawnDrone);
        if (!isNull _drone) then {_spawned pushBack _drone};
    };
    if (isNull _drone) exitWith {};
};
if (_mode isEqualTo FEED_MODE_DRONE && {isNull _drone}) exitWith {
    {deleteVehicle _x} forEach _spawned;
    DBG("drone feed rejected, no drone");
};

private _droneRef = if (isNull _drone) then {""} else {netId _drone};
private _feedId = format ["df_%1_%2", diag_frameNo, floor random 1000000];
private _rttRes = GVAR(textureResolution);
private _cycleInterval = GVAR(autoCycleInterval);

// Start the effect: the anchor JIP-broadcasts the client setup and lets the
// Terminate module and stopEffect clean the whole feed up later.
private _setupParams = [_feedId, netId _screen, _droneRef, _mode, _textureId, _rttRes, _radius, _renderMode, _view, _satAlt, _proxyAlt, _cycleInterval];
private _anchor = ["dronefeed", QGVAR(setupLocal), _setupParams, _center] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {
    {deleteVehicle _x} forEach _spawned;
};

// Objects we spawned are deleted with the anchor; pre-existing ones are left be.
_anchor setVariable [QEGVAR(main,attachedObjects), _spawned];

// Mutable feed state lives on the screen so clients can diff it per frame and
// JIP clients pick up the current values for free.
_screen setVariable [QGVAR(feedId), _feedId, true];
_screen setVariable [QGVAR(anchor), _anchor, true];
_screen setVariable [QGVAR(mode), _mode, true];
_screen setVariable [QGVAR(droneNetId), _droneRef, true];
_screen setVariable [QGVAR(view), _view, true];
_screen setVariable [QGVAR(zoom), DEFAULT_FOV, true];
_screen setVariable [QGVAR(vision), 0, true];
_screen setVariable [QGVAR(renderMode), _renderMode, true];
_screen setVariable [QGVAR(satPos), [_center select 0, _center select 1], true];
_screen setVariable [QGVAR(satAlt), _satAlt, true];
_screen setVariable [QGVAR(proxyAlt), _proxyAlt, true];
_screen setVariable [QGVAR(controller), objectFromNetId _controllerNetId, true];

GVAR(feeds) set [_feedId, [_anchor, _screen, _drone, _mode]];

DBG(FORMAT_2("drone feed %1 created, mode %2",_feedId,_mode));
