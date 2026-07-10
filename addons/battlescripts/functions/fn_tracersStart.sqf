#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts an ambient tracer source on the server: creates the anchor and
 * broadcasts the setup to all clients (JIP safe). Tracer volleys and the
 * gunfire sound are generated locally on every client with no further
 * network traffic.
 *
 * Arguments:
 * 0: Position ATL of the tracer source <ARRAY>
 * 1: Minimum player distance before tracers are shown <NUMBER>
 * 2: Tracer color as [r, g, b] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 150, [1, 0.3, 0.3]] call root_effects_battlescripts_fnc_tracersStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_activationDistance", 150, [0]],
    ["_color", [1, 1, 1], [[]], 3]
];

if (!isServer) exitWith {};
if (!(["tracers"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchor = ["tracers", QGVAR(tracersLocal), [_activationDistance, _color], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("tracer fire started, activation distance %1",_activationDistance));
