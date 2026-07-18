#include "..\script_component.hpp"

/*
 * Author: Root
 * Stops every running feed on the server, deleting anything spawned for them.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call root_effects_dronefeed_fnc_serverKillAll
 */

if (!isServer) exitWith {};

{
    [[_x, true]] call FUNC(serverDeleteFeed);
} forEach keys GVAR(feeds);

DBG("all drone feeds stopped");
