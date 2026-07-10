#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing map script by the 77th JSOC community
 * Starts a live briefing map on the server: places the physical map board
 * and broadcasts the feed setup to all clients (JIP safe). The live map
 * itself is drawn locally on every client; nothing but the board object
 * crosses the network.
 *
 * Arguments:
 * 0: Position ATL of the board <ARRAY>
 * 1: Facing direction of the board <NUMBER>
 * 2: Marker the map centers on, "" for the board position <STRING>
 * 3: Map zoom, smaller is closer <NUMBER>
 * 4: Player distance at which the feed refreshes <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 90, "", 0.1, 50] call root_effects_briefing_fnc_briefingMapStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_dir", 0, [0]],
    ["_centerMarker", "", [""]],
    ["_zoom", 0.1, [0]],
    ["_activationDistance", 50, [0]]
];

if (!isServer) exitWith {};
if (!(["briefingmap"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchor = ["briefingmap", QGVAR(mapLocal), [_centerMarker, _zoom, _activationDistance], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

private _board = createVehicle ["Land_MapBoard_F", _pos, [], 0, "CAN_COLLIDE"];
_board setDir _dir;
_board setPosATL _pos;
_board enableSimulationGlobal false;

// The board travels with the instance: broadcast to clients through the
// anchor and released together with it by the termination module.
_anchor setVariable [QGVAR(board), _board, true];
_anchor setVariable [QEGVAR(main,attachedObjects), [_board]];

DBG(FORMAT_1("briefing map started, marker %1",_centerMarker));
