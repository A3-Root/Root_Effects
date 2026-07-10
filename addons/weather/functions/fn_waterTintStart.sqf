#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts a water tint zone on the server: creates the anchor and broadcasts
 * the setup to all clients (JIP safe). The tint is a purely local color
 * grading on every client, doubled in strength while the player is
 * underwater, so a running zone costs no network traffic.
 *
 * Arguments:
 * 0: Position ATL of the zone center <ARRAY>
 * 1: Zone radius in meters <NUMBER>
 * 2: Color index: 0 blood red, 1 toxic green, 2 ink black <NUMBER>
 * 3: Tint strength 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500, 0, 0.6] call root_effects_weather_fnc_waterTintStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 500, [0]],
    ["_colorIndex", 0, [0]],
    ["_strength", 0.6, [0]]
];

if (!isServer) exitWith {};
if (!(["watertint"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchor = ["watertint", QGVAR(waterTintLocal), [_radius, _colorIndex, _strength], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_2("water tint started, radius %1, color %2",_radius,_colorIndex));
