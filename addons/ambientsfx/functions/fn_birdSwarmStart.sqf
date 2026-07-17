#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts an ambient bird swarm on the server: creates the anchor and asks
 * every client to render its own flock. The birds are a pure visual, so each
 * machine keeps its own local copies rather than paying for network synced
 * agents. Deleting the anchor removes the flock everywhere.
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

private _anchor = ["birdswarm", QGVAR(birdSwarmLocal), [_count, _radius], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_2("bird swarm started, %1 birds, radius %2",_count,_radius));
