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
 * 2: Shape: 0 band, 1 arc, 2 wave, 3 ring, 4 spiral, 5 random <NUMBER>
 * 3: Fade in (spawn) seconds <NUMBER>
 * 4: Fade out (despawn) seconds <NUMBER>
 * 5: Particle lifetime seconds <NUMBER>
 * 6: Density 0.1 - 1 <NUMBER>
 * 7: Fixed in place, no despawn or new spawn <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500] call root_effects_ambientsfx_fnc_ruptureStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_altitude", 500, [0]],
    ["_shape", 0, [0]],
    ["_fadeIn", 20, [0]],
    ["_fadeOut", 20, [0]],
    ["_lifetime", 180, [0]],
    ["_density", 0.5, [0]],
    ["_fixed", false, [false]]
];

if (!isServer) exitWith {};
if (!(["rupture"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["rupture", QGVAR(ruptureLocal), [_shape, _fadeIn, _fadeOut, _lifetime, _density, _fixed, floor random 1e6], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("rupture started at altitude %1",_altitude));
