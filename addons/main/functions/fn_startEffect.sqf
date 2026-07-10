#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts a new effect instance on the server. Creates an invisible anchor
 * object at the requested position, broadcasts the effect's start event to
 * all machines (including future JIP clients, keyed to the anchor so the
 * broadcast disappears with it) and tracks the instance for the termination
 * module. The anchor is prepended to the event parameters, so client side
 * handlers always receive [anchor, ...customParams].
 *
 * Arguments:
 * 0: Unique effect key used at registration <STRING>
 * 1: CBA event name raised on all machines, "" for effects whose clients
 *    only react to later one-shot events <STRING>
 * 2: Additional event parameters <ARRAY>
 * 3: Effect position ATL <ARRAY>
 *
 * Return Value:
 * Anchor object of the new instance, objNull on failure <OBJECT>
 *
 * Example:
 * ["volcano", "root_effects_volcano_startLocal", [50], [1000, 2000, 0]] call root_effects_main_fnc_startEffect
 */

params [["_effectKey", "", [""]], ["_startEvent", "", [""]], ["_params", [], [[]]], ["_pos", [0, 0, 0], [[]], 3]];

if (!isServer) exitWith {objNull};
if (_effectKey isEqualTo "") exitWith {objNull};

private _anchor = createVehicle [ANCHOR_CLASS, _pos, [], 0, "CAN_COLLIDE"];
_anchor setPosATL _pos;

_anchor setVariable [QGVAR(effectKey), _effectKey, true];
_anchor setVariable [QGVAR(startTime), CBA_missionTime];

// Anchor object doubles as the JIP id: CBA drops the queued event
// automatically once the anchor is deleted.
if (_startEvent isNotEqualTo "") then {
    [_startEvent, [_anchor] + _params, _anchor] call CBA_fnc_globalEventJIP;
};

private _list = GVAR(instances) getOrDefault [_effectKey, []];
_list pushBack _anchor;
GVAR(instances) set [_effectKey, _list];

DBG(FORMAT_2("started effect %1 at %2",_effectKey,mapGridPosition _anchor));

_anchor
