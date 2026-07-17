#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies damage to a unit on the machine where that unit is local. Infantry
 * gets routed through ACE medical when that is loaded, everything else (or a
 * vanilla setup) receives plain damage. Called directly by FUNC(doDamage) when
 * the server already owns the unit, otherwise raised as an event on the
 * owning machine.
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
 * [_unit, 0.5, "Body", "burn"] call root_effects_main_fnc_doDamageLocal
 */

params [["_unit", objNull, [objNull]], ["_damage", 0, [0]], ["_bodyPart", "Body", [""]], ["_damageType", "explosive", [""]], ["_source", objNull, [objNull]]];

if (isNull _unit || {!alive _unit} || {_damage <= 0}) exitWith {};

if (_unit isKindOf "CAManBase" && GVAR(aceMedicalLoaded)) then {
    [_unit, _damage, _bodyPart, _damageType, _source] call (missionNamespace getVariable "ace_medical_fnc_addDamageToUnit");
} else {
    _unit setDamage [((damage _unit) + _damage) min 1, false];
};
