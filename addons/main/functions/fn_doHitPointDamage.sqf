#include "..\script_component.hpp"

/*
 * Author: Root
 * Adds damage to every hitpoint of a vehicle from the server, honouring the
 * global damage kill-switch setting. setHitPointDamage only takes effect on
 * the machine owning the vehicle, so the work is routed to that machine when
 * the server does not own it (any player-flown aircraft).
 *
 * Arguments:
 * 0: Vehicle to damage <OBJECT>
 * 1: Damage to add per hitpoint, 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_heli, 0.2] call root_effects_main_fnc_doHitPointDamage
 */

params [["_vehicle", objNull, [objNull]], ["_damage", 0, [0]]];

if (!isServer) exitWith {};
if (!GVAR(damageAllowed)) exitWith {};
if (isNull _vehicle || {!alive _vehicle} || {_damage <= 0}) exitWith {};

if (local _vehicle) exitWith {
    [_vehicle, _damage] call FUNC(doHitPointDamageLocal);
};

[QGVAR(hitPointDamageLocal), [_vehicle, _damage], _vehicle] call CBA_fnc_targetEvent;
