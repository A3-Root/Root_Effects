#include "..\script_component.hpp"

/*
 * Author: Root
 * Checks whether an item is electronic: night vision, radio and GPS / terminal slot
 * items, weapon lights and lasers, binoculars with night, thermal or laser
 * function, cTab and ACE devices, ACRE radios, plus the field's extra list.
 * The field's immune list overrides everything.
 *
 * Arguments:
 * 0: Classname <STRING>
 * 1: Field settings <HASHMAP> (optional)
 *
 * Return Value:
 * Electronic <BOOL>
 *
 * Example:
 * ["ItemcTab", _cfg] call root_effects_emp_fnc_empIsElectronic
 */

params [["_class", "", [""]], ["_cfg", createHashMap, [createHashMap]]];

if (_class isEqualTo "") exitWith {false};

private _lower = toLowerANSI _class;
private _fnc_list = {
    params ["_key"];
    ((_cfg getOrDefault [_key, ""]) splitString ",") apply {toLowerANSI trim _x}
};
if (_lower in (["itemsImmune"] call _fnc_list)) exitWith {false};
if (_lower in (["itemsExtra"] call _fnc_list)) exitWith {true};

if (isNil QGVAR(electronicCache)) then {GVAR(electronicCache) = createHashMap};
private _cached = GVAR(electronicCache) get _lower;
if (!isNil "_cached") exitWith {_cached};

private _known = [
    "itemctab", "itemandroid", "itemmicrodagr", "itemctabhcam", "itemctabmisc", "itemandroidmisc",
    "ace_microdagr", "ace_dagr", "ace_huntir_monitor", "ace_kestrel4500", "ace_atragmx",
    "ace_vector", "ace_vectorday", "ace_mx2a", "ace_yardage450", "ace_spottingscope",
    "acre_gen_satcom", "acre_gen_satcomitem"
];

private _config = configFile >> "CfgWeapons" >> _class;
private _result = switch (true) do {
    case (_lower in _known): {true};
    case (!isClass _config): {false};
    case (getNumber (_config >> "ItemInfo" >> "type") in [301, 611, 616, 621]): {true};
    case (getNumber (_config >> "type") == 4096): {
        private _modes = (getArray (_config >> "visionMode")) apply {toLowerANSI _x};
        "nvg" in _modes || {"ti" in _modes} || {_class isKindOf ["Laserdesignator", configFile >> "CfgWeapons"]} || {_class isKindOf ["Rangefinder", configFile >> "CfgWeapons"]}
    };
    case (!isNil "acre_api_fnc_isRadio"): {[_class] call acre_api_fnc_isRadio};
    default {false};
};

GVAR(electronicCache) set [_lower, _result];
_result
