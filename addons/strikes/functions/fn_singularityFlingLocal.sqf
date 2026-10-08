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
private _velocity = [
    (random 16 - 8) * _strength,
    (random 16 - 8) * _strength,
    _lift * _strength
];

// A soldier on foot ignores setVelocity while his animation holds him to the ground,
// so a heavy throwaway prop is hooked to him for an instant to knock him into ragdoll.
if (_target isKindOf "CAManBase" && {isNull objectParent _target}) exitWith {
    private _hook = "Land_PenBlack_F" createVehicleLocal [0, 0, 0];
    _hook attachTo [_target, [0, 0, 0], "Spine3"];
    _target setVelocity _velocity;
    [{
        params ["_hook", "_target", "_velocity"];
        _hook setMass 1e10;
        _hook setVelocity _velocity;
        [{
            params ["_hook"];
            detach _hook;
            deleteVehicle _hook;
        }, [_hook], 0.05] call CBA_fnc_waitAndExecute;
    }, [_hook, _target, _velocity], 0.1] call CBA_fnc_waitAndExecute;
};

_target setVelocity _velocity;
