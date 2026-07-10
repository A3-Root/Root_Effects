#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts a spacetime rupture on the server: creates the anchor at the chosen
 * altitude and broadcasts the setup to all clients (JIP safe). The rupture
 * band is rendered locally by each client during the night.
 *
 * Arguments:
 * 0: Position ATL of the rupture <ARRAY>
 * 1: Altitude of the rupture above terrain in meters <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500] call root_effects_ambientsfx_fnc_ruptureStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_altitude", 500, [0]]
];

if (!isServer) exitWith {};
if (!(["rupture"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["rupture", QGVAR(ruptureLocal), [], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("rupture started at altitude %1",_altitude));
