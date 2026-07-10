#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts an ambient bird swarm on the server: creates the anchor and spawns
 * a flock of eagle agents circling the area. A slow herding loop teleports
 * stray birds back over the flock center. The agents are engine driven, so
 * the flock needs no per frame scripting; deleting the anchor removes the
 * whole flock.
 *
 * Arguments:
 * 0: Position ATL of the flock center <ARRAY>
 * 1: Number of birds <NUMBER>
 * 2: Radius the flock roams in meters <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 15, 150] call root_effects_ambientsfx_fnc_birdSwarmStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_count", 15, [0]],
    ["_radius", 150, [0]]
];

if (!isServer) exitWith {};
if (!(["birdswarm"] call EFUNC(main,isEffectEnabled))) exitWith {};

_count = (_count max 1) min GVAR(maxSwarmBirds);
_radius = _radius max 50;

private _anchor = ["birdswarm", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

private _birds = [];
for "_i" from 1 to _count do {
    private _spawnPos = _anchor getPos [random _radius, random 360];
    _spawnPos set [2, 30 + random 60];

    private _bird = createAgent ["Eagle_F", _spawnPos, [], 0, "FLY"];
    _bird setPosATL _spawnPos;
    _birds pushBack _bird;
};

// Anchor deletion through the termination module removes the flock too.
_anchor setVariable [QEGVAR(main,attachedObjects), _birds];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    {
        if (!isNull _x && {(_x distance2D _anchor) > _radius * 1.5}) then {
            private _returnPos = _anchor getPos [random (_radius * 0.5), random 360];
            _returnPos set [2, 30 + random 60];
            _x setPosATL _returnPos;
        };
    } forEach (_anchor getVariable [QEGVAR(main,attachedObjects), []]);
}, 10, [_anchor, _radius]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("bird swarm started, %1 birds, radius %2",_count,_radius));
