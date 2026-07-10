#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts a heat mirage zone on the server: creates the anchor and broadcasts
 * the setup to all clients (JIP safe). The haze itself is a purely local
 * post process effect on every client, so the running zone costs no network
 * traffic at all.
 *
 * Arguments:
 * 0: Position ATL of the zone center <ARRAY>
 * 1: Zone radius in meters <NUMBER>
 * 2: Haze intensity 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 200, 0.5] call root_effects_weather_fnc_mirageStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 200, [0]],
    ["_intensity", 0.5, [0]]
];

if (!isServer) exitWith {};
if (!(["heatmirage"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchor = ["heatmirage", QGVAR(mirageLocal), [_radius, _intensity], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_2("heat mirage started, radius %1, intensity %2",_radius,_intensity));
