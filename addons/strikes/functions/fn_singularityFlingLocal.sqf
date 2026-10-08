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

DBG(FORMAT_1("singularityFlingLocal called with %1",_this));

if (isNull _target) exitWith {};

// Mostly upward with a lateral kick, so the pile comes apart as it rises.
private _lift = 12 + random 14;
private _velocity = [
    (random 16 - 8) * _strength,
    (random 16 - 8) * _strength,
    _lift * _strength
];

// A soldier on foot ignores setVelocity while his animation holds him to the
// ground. Same trick as the Steamer and Worm anomalies: a pen with enormous mass is
// hooked to his spine and fired along with him, which tears him into ragdoll and
// carries him up and away.
if (_target isKindOf "CAManBase" && {isNull objectParent _target}) exitWith {
    [_target, _velocity] spawn {
        params ["_target", "_velocity"];
        private _hook = "Land_PenBlack_F" createVehicle [0, 0, 0];
        _hook attachTo [_target, [0, 0, 0], "Spine3"];
        _target setVelocity _velocity;
        uiSleep 0.1;
        _hook setMass 1e10;
        _hook setVelocity _velocity;
        uiSleep 0.01;
        detach _hook;
        uiSleep 0.5;
        deleteVehicle _hook;
    };
    DBG(FORMAT_3("singularity threw %1 (%2) with %3",name _target,typeOf _target,_velocity));
};

_target setVelocity _velocity;
