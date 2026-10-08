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
    ["_fixed", false, [false]],
    ["_sizeScale", 1, [0]],
    ["_lengthScale", 1, [0]],
    ["_switchInterval", 0, [0]],
    ["_moveSpeed", 0, [0]],
    ["_moveMode", 0, [0]]
];

DBG(FORMAT_1("ruptureStart called with %1",_this));

if (!isServer) exitWith {};
if (!(["rupture"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["rupture", QGVAR(ruptureLocal), [_fadeIn, _fadeOut, _lifetime, _density], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// Live settings the renderers follow, and the switch/move control. Fixed in place
// starts the band held: it fills up once and then never changes.
[
    _anchor,
    [true, !_fixed, (_sizeScale max 0.2) min 5, (_lengthScale max 0.2) min 5, _shape, floor random 1e6],
    [_switchInterval max 0, _shape, (_moveSpeed max 0) min 100, _moveMode]
] call FUNC(skyServer);

DBG(FORMAT_4("rupture started at %1, altitude %2, shape %3, fixed %4",mapGridPosition _anchorPos,_altitude,_shape,_fixed));
