#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts an aurora borealis on the server: creates the anchor at the chosen
 * altitude and broadcasts the setup to all clients (JIP safe). The glowing
 * bands are rendered locally by each client during the night.
 *
 * Arguments:
 * 0: Position ATL of the aurora <ARRAY>
 * 1: Altitude of the aurora above terrain in meters <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500] call root_effects_ambientsfx_fnc_auroraStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_altitude", 500, [0]]
];

if (!isServer) exitWith {};
if (!(["aurora"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["aurora", QGVAR(auroraLocal), [], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("aurora started at altitude %1",_altitude));
