#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Spawns one comet on the server near a random player: creates the global
 * comet body streaking across the sky, broadcasts the client side glow
 * visuals and removes the body after a few seconds.
 *
 * Arguments:
 * 0: Spawner anchor <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor] call root_effects_meteor_fnc_spawnComet
 */

params [["_anchor", objNull, [objNull]]];

if (!isServer) exitWith {};

private _target = [
    getPosATL _anchor,
    _anchor getVariable [QGVAR(targetMode), 0],
    _anchor getVariable [QGVAR(targetRadius), 300],
    _anchor getVariable [QGVAR(targetOwners), []]
] call FUNC(pickTarget);
private _startPos = [
    (_target select 0) + random (selectRandom [500, -500]),
    (_target select 1) + random (selectRandom [500, -500]),
    800
];

private _comet = createVehicle ["Land_Battery_F", _startPos, [], 0, "CAN_COLLIDE"];
_comet setPosATL _startPos;

private _destX = (_startPos select 0) + (random 40000 * selectRandom [1, -1]);
private _destY = (_startPos select 1) + (random 40000 * selectRandom [1, -1]);

[QGVAR(cometLocal), [_comet]] call CBA_fnc_globalEvent;

_comet setVelocity [_destX / 100, _destY / 100, -1];

[{
    params ["_comet"];
    deleteVehicle _comet;
}, [_comet], 4 + random 2] call CBA_fnc_waitAndExecute;
