#include "..\script_component.hpp"

/*
 * Author: Root
 * Stops a single feed on the server. Optionally keeps the screen and drone that
 * were spawned for it by detaching them from the anchor before the shared
 * stopEffect tears the instance down.
 *
 * Arguments (single array):
 * 0: Feed id <STRING>
 * 1: Also delete objects that were spawned for the feed <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [["df_12_345", true]] call root_effects_dronefeed_fnc_serverDeleteFeed
 */

params [["_args", [], [[]]]];
_args params [["_feedId", "", [""]], ["_deleteSpawned", true, [false]]];

if (!isServer) exitWith {};

private _entry = GVAR(feeds) getOrDefault [_feedId, []];
if (_entry isEqualTo []) exitWith {};
_entry params ["_anchor", "_screen"];

// Clear the feed markers off the screen so a kept screen is a plain prop again.
if (!isNull _screen) then {
    {
        _screen setVariable [_x, nil, true];
    } forEach [QGVAR(feedId), QGVAR(anchor), QGVAR(mode), QGVAR(droneNetId), QGVAR(view), QGVAR(zoom), QGVAR(vision), QGVAR(renderMode), QGVAR(satPos), QGVAR(satAlt), QGVAR(proxyAlt), QGVAR(controller)];
};

// Keep spawned objects by detaching them before the anchor is deleted.
if (!_deleteSpawned && {!isNull _anchor}) then {
    _anchor setVariable [QEGVAR(main,attachedObjects), [], true];
};

if (!isNull _anchor) then {
    ["dronefeed", _anchor] call EFUNC(main,stopEffect);
};

GVAR(feeds) deleteAt _feedId;

DBG(FORMAT_1("drone feed %1 deleted",_feedId));
