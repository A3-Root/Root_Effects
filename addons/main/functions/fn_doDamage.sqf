#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies damage to a unit from the server, honouring the global damage
 * kill-switch setting. Damage commands only take effect on the machine owning
 * the unit, so the work is routed there when the server does not own it (any
 * player, and AI handed to a headless client).
 *
 * Arguments:
 * 0: Unit or vehicle to damage <OBJECT>
 * 1: Damage to add, 0..1 <NUMBER>
 * 2: Body part hit, ACE medical selection name <STRING> (default: "Body")
 * 3: ACE medical damage type <STRING> (default: "explosive")
 * 4: Damage source <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, 0.5, "Body", "burn"] call root_effects_main_fnc_doDamage
 */

params [["_unit", objNull, [objNull]], ["_damage", 0, [0]], ["_bodyPart", "Body", [""]], ["_damageType", "explosive", [""]], ["_source", objNull, [objNull]]];

if (!isServer) exitWith {};
if (!GVAR(damageAllowed)) exitWith {};
if (isNull _unit || {!alive _unit} || {_damage <= 0}) exitWith {};

if (local _unit) exitWith {
    [_unit, _damage, _bodyPart, _damageType, _source] call FUNC(doDamageLocal);
};

[QGVAR(doDamageLocal), [_unit, _damage, _bodyPart, _damageType, _source], _unit] call CBA_fnc_targetEvent;
