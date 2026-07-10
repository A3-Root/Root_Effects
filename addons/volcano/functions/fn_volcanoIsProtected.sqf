#include "..\script_component.hpp"

/*
 * Author: Root
 * Checks whether a unit wears every configured piece of protective gear.
 * With an empty gear list nothing can protect, so the unit counts as
 * unprotected.
 *
 * Arguments:
 * 0: Unit to check <OBJECT>
 * 1: Required gear class names <ARRAY>
 *
 * Return Value:
 * Unit is fully protected <BOOL>
 *
 * Example:
 * [_unit, ["B_KitbagMcamo"]] call root_effects_volcano_fnc_volcanoIsProtected
 */

params [["_unit", objNull, [objNull]], ["_gear", [], [[]]]];

if (isNull _unit || {_gear isEqualTo []}) exitWith {false};

private _equipped = [headgear _unit, goggles _unit, uniform _unit, vest _unit, backpack _unit];

(_gear findIf {!(_x in _equipped)}) == -1
