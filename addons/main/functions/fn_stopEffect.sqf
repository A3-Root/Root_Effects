#include "..\script_component.hpp"

/*
 * Author: Root
 * Stops one or all running instances of an effect on the server. Deleting an
 * instance's anchor removes its JIP broadcast, releases every helper object
 * the effect stored on the anchor and signals all client side loops (which
 * watch the anchor) to shut down and clean up on their own.
 *
 * Arguments:
 * 0: Unique effect key used at registration <STRING>
 * 1: Anchor of the instance to stop, or "ALL" for every instance <OBJECT|STRING> (default: "ALL")
 *
 * Return Value:
 * None
 *
 * Example:
 * ["volcano", "ALL"] call root_effects_main_fnc_stopEffect
 */

params [["_effectKey", "", [""]], ["_target", "ALL", ["", objNull]]];

if (!isServer) exitWith {};

private _anchors = GVAR(instances) getOrDefault [_effectKey, []];
private _toStop = if (_target isEqualType objNull) then {[_target]} else {+_anchors};

{
    private _anchor = _x;
    if (!isNull _anchor) then {
        private _helpers = _anchor getVariable [QGVAR(attachedObjects), []];
        {
            deleteVehicle _x;
        } forEach _helpers;

        // Clear any persistent local props (craters, decals) this instance left
        // on each machine before the anchor and its netId disappear.
        [QGVAR(cleanupLocalObjects), [netId _anchor]] call CBA_fnc_globalEvent;

        deleteVehicle _anchor;
    };
} forEach _toStop;

_anchors = _anchors select {!isNull _x};
GVAR(instances) set [_effectKey, _anchors];

DBG(FORMAT_2("stopped effect %1 (%2 instances remain)",_effectKey,count _anchors));
