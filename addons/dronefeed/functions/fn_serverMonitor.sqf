#include "..\script_component.hpp"

/*
 * Author: Root
 * Periodic server sweep that stops any feed whose screen has vanished or whose
 * drone has been destroyed, so dead feeds do not linger in the registry.
 *
 * Arguments:
 * 0: PFH arguments (unused) <ARRAY>
 * 1: PFH handle <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [FUNC(serverMonitor), 5, []] call CBA_fnc_addPerFrameHandler
 */

if (!isServer) exitWith {};

{
    _y params ["_anchor", "_screen", "_drone", "_mode"];
    private _dead = isNull _anchor
        || {isNull _screen}
        || {_mode isEqualTo FEED_MODE_DRONE && {isNull _drone || {!alive _drone}}};

    if (_dead) then {
        [[_x, true]] call FUNC(serverDeleteFeed);
    };
} forEach GVAR(feeds);
