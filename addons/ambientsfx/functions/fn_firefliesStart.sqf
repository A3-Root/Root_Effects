#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts an ambient firefly swarm on the server: creates the anchor and
 * broadcasts the setup to all clients (JIP safe). The fireflies themselves
 * are rendered locally by each client at night when the player is close.
 *
 * Arguments:
 * 0: Position ATL of the swarm <ARRAY>
 * 1: Altitude of the swarm above terrain in meters <NUMBER>
 * 2: Player distance at which the swarm appears <NUMBER>
 * 3: Play ambient frog croaks at night <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 1, 100, true] call root_effects_ambientsfx_fnc_firefliesStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_altitude", 1, [0]],
    ["_activationDistance", 100, [0]],
    ["_frogs", true, [false]]
];

if (!isServer) exitWith {};
if (!(["fireflies"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["fireflies", QGVAR(firefliesLocal), [_activationDistance, _frogs], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("fireflies started, activation distance %1",_activationDistance));
