#include "..\script_component.hpp"

/*
 * Author: Root
 * Removes every electronic item a unit carries: goggles, GPS / terminal slot,
 * binoculars, weapon lights and lasers, devices and radios in the inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Field settings <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _cfg] call root_effects_emp_fnc_empFry
 */

params [["_unit", objNull, [objNull]], ["_cfg", createHashMap, [createHashMap]]];

if (!local _unit) exitWith {};

private _fnc_is = {[_this, _cfg] call FUNC(empIsElectronic)};

[QGVAR(sparks), [_unit, false, 0.9]] call CBA_fnc_globalEvent;

{
    if (_x call _fnc_is) then {
        _unit unlinkItem _x;
        _unit removeItem _x;
    };
} forEach (assignedItems _unit);

private _bino = binocular _unit;
if (_bino call _fnc_is) then {_unit removeWeapon _bino};

private _pointer = (primaryWeaponItems _unit) param [1, ""];
if (_pointer isNotEqualTo "" && {_pointer call _fnc_is}) then {_unit removePrimaryWeaponItem _pointer};
_pointer = (handgunItems _unit) param [1, ""];
if (_pointer isNotEqualTo "" && {_pointer call _fnc_is}) then {_unit removeHandgunItem _pointer};
_pointer = (secondaryWeaponItems _unit) param [1, ""];
if (_pointer isNotEqualTo "" && {_pointer call _fnc_is}) then {_unit removeSecondaryWeaponItem _pointer};

{
    if (_x call _fnc_is) then {_unit removeItems _x};
} forEach ((items _unit) arrayIntersect (items _unit));

DBG(FORMAT_1("EMP fried electronics of %1",name _unit));
