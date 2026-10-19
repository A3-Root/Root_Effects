#include "..\script_component.hpp"

/*
 * Author: Root
 * With settings: takes the electronic devices a local unit carries (GPS slot,
 * terminals, cTab, ACE devices, extra items) and keeps them on the unit as a stash.
 * Goggles, binoculars, weapon attachments and radios stay. Without settings:
 * gives the stash back, devices in their slot again, the rest into the inventory,
 * on the ground when it is full.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Field settings <HASHMAP> (optional, none gives the stash back)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _cfg] call root_effects_emp_fnc_empStash
 */

params [["_unit", objNull, [objNull]], ["_cfg", nil, [createHashMap]]];

if (isNull _unit || {!local _unit}) exitWith {};

private _stash = _unit getVariable [QGVAR(stash), []];
private _fnc_type = {getNumber (configFile >> "CfgWeapons" >> _this >> "ItemInfo" >> "type")};

// Give back.
if (isNil "_cfg") exitWith {
    if (_stash isEqualTo []) exitWith {};
    _unit setVariable [QGVAR(stash), nil];
    private _holder = objNull;
    {
        _x params ["_class", "_assigned"];
        private _type = _class call _fnc_type;
        private _slotFree = (assignedItems _unit) findIf {(_x call _fnc_type) == _type} == -1;
        if (_assigned && _slotFree) then {
            _unit linkItem _class;
        } else {
            if (_unit canAdd _class) then {
                _unit addItem _class;
            } else {
                if (isNull _holder) then {
                    _holder = createVehicle ["GroundWeaponHolder", getPosATL _unit, [], 0, "CAN_COLLIDE"];
                };
                _holder addItemCargoGlobal [_class, 1];
            };
        };
    } forEach _stash;
    DBG(FORMAT_2("EMP gave back %1 devices to %2",count _stash,name _unit));
};

// Take.
private _fnc_take = {
    params ["_class"];
    if (_class isEqualTo "" || {_class isEqualTo hmd _unit} || {_class isEqualTo binocular _unit}) exitWith {false};
    private _lower = toLowerANSI _class;
    if ((_class call _fnc_type) in [101, 201, 301, 302, 611, 616]) exitWith {false};
    if (_class isKindOf ["ItemRadio", configFile >> "CfgWeapons"]) exitWith {false};
    if (["acre_", "tf_", "tfar_"] findIf {(_lower find _x) == 0} != -1) exitWith {false};
    if (!isNil "acre_api_fnc_isRadio" && {[_class] call acre_api_fnc_isRadio}) exitWith {false};
    [_class, _cfg] call FUNC(empIsElectronic)
};

private _taken = 0;
{
    if ([_x] call _fnc_take) then {
        _unit unlinkItem _x;
        _unit removeItem _x;
        _stash pushBack [_x, true];
        _taken = _taken + 1;
    };
} forEach (assignedItems _unit);
{
    private _class = _x;
    if ([_class] call _fnc_take) then {
        {
            if (_x isEqualTo _class) then {_stash pushBack [_class, false]};
        } forEach (items _unit);
        _unit removeItems _class;
        _taken = _taken + 1;
    };
} forEach ((items _unit) arrayIntersect (items _unit));

if (_taken > 0) then {
    _unit setVariable [QGVAR(stash), _stash];
    DBG(FORMAT_2("EMP took devices from %1, stash %2",name _unit,_stash));
};
