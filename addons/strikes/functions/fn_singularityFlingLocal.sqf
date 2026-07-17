#include "..\script_component.hpp"

/*
 * Author: Root
 * Throws one object into the air on the machine that owns it. Velocity only
 * applies where the object is local, so the server routes every affected
 * object here rather than setting it directly.
 *
 * Arguments:
 * 0: Object to throw <OBJECT>
 * 1: Strength of the throw, 0..1 by distance from the anomaly <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, 0.8] call root_effects_strikes_fnc_singularityFlingLocal
 */

params [["_target", objNull, [objNull]], ["_strength", 1, [0]]];

if (isNull _target) exitWith {};

// Mostly upward with a lateral kick, so the pile comes apart as it rises.
private _lift = 12 + random 14;
_target setVelocity [
    (random 16 - 8) * _strength,
    (random 16 - 8) * _strength,
    _lift * _strength
];
