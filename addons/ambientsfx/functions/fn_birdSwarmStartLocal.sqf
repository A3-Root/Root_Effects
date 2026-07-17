#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side visuals for one bird swarm: a flock of local birds circling the
 * anchor on their own orbits at a lazy drift. The flock only exists while the
 * player is within view distance; a slow watcher creates and tears it down and
 * ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Number of birds <NUMBER>
 * 2: Radius the flock roams in meters <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 15, 150] call root_effects_ambientsfx_fnc_birdSwarmStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_count", 15, [0]], ["_radius", 150, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, count, radius, birds]
private _state = [_anchor, _count, _radius, []];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_count", "_radius", "_birds"];

    if (isNull _anchor) exitWith {
        {
            deleteVehicle (_x select 0);
        } forEach _birds;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inRange = (player distance2D _anchor) < EGVAR(main,maxViewDistance);

    if (_inRange && {_birds isEqualTo []}) then {
        private _center = getPosATL _anchor;

        for "_i" from 1 to _count do {
            private _bird = createVehicleLocal ["Eagle_F", _center, [], 0, "CAN_COLLIDE"];

            // Each bird keeps its own orbit so the flock never flies in lockstep:
            // [bird, angle, orbitRadius, height, angular speed, bank direction]
            private _orbitRadius = _radius * (0.25 + random 0.75);
            private _birdState = [
                _bird,
                random 360,
                _orbitRadius,
                30 + random 60,
                (12 + random 18) * (selectRandom [1, -1]),
                0
            ];
            _birds pushBack _birdState;
        };
        _args set [3, _birds];
    };

    if (!_inRange && {_birds isNotEqualTo []}) then {
        {
            deleteVehicle (_x select 0);
        } forEach _birds;
        _args set [3, []];
    };
}, 2, _state] call CBA_fnc_addPerFrameHandler;

// Fast loop flying the birds around their orbits. Velocity is what drives the
// engine's glide animation, so it is set alongside the position each step.
[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_count", "_radius", "_birds"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _center = getPosATL _anchor;

    {
        _x params ["_bird", "_angle", "_orbitRadius", "_height", "_angularSpeed"];
        if (isNull _bird) then {continue};

        private _newAngle = (_angle + _angularSpeed * 0.5) % 360;
        _x set [1, _newAngle];

        private _pos = [
            (_center select 0) + _orbitRadius * sin _newAngle,
            (_center select 1) + _orbitRadius * cos _newAngle,
            _height
        ];

        // Tangent of the orbit, which is both the heading and the direction of
        // travel; scaled to a plausible glide speed.
        private _speed = (abs _angularSpeed) * _orbitRadius * (pi / 180);
        private _dirX = cos _newAngle * (_angularSpeed / abs _angularSpeed);
        private _dirY = -sin _newAngle * (_angularSpeed / abs _angularSpeed);

        _bird setPosATL _pos;
        _bird setDir (_dirX atan2 _dirY);
        _bird setVelocity [_dirX * _speed, _dirY * _speed, 0];
    } forEach _birds;
}, 0.5, _state] call CBA_fnc_addPerFrameHandler;
