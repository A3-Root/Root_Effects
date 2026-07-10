#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts a crop circle on the server: creates the anchor and broadcasts the
 * animation to all clients. The circle is drawn by a glowing orb burning
 * flattened decals into the ground; the decals stay behind as the finished
 * crop circle.
 *
 * Arguments:
 * 0: Position ATL of the circle center <ARRAY>
 * 1: Circle radius in meters <NUMBER>
 * 2: Pattern "circle", "spiral" or "flower" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 50, "circle"] call root_effects_ufo_fnc_cropCircleStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 50, [0]],
    ["_cropType", "circle", [""]]
];

if (!isServer) exitWith {};
if (!(["cropcircle"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchor = ["cropcircle", QGVAR(cropCircleLocal), [_radius, _cropType], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_2("crop circle started, radius %1, pattern %2",_radius,_cropType));
