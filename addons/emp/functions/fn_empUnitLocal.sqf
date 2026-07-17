#include "..\script_component.hpp"

/*
 * Author: Root
 * Knocks out the electronics a single unit carries: night vision goggles,
 * weapon lights and IR pointers. Runs on the machine owning the unit because
 * inventory and weapon accessory commands only take effect there. Unless the
 * damage is permanent the gear is handed back once the interference passes.
 *
 * Arguments:
 * 0: Affected unit <OBJECT>
 * 1: Interference duration in seconds <NUMBER>
 * 2: Gear is destroyed rather than disrupted <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, 20, false] call root_effects_emp_fnc_empUnitLocal
 */

params [["_unit", objNull, [objNull]], ["_duration", 20, [0]], ["_permanent", false, [false]]];

if (isNull _unit || {!alive _unit}) exitWith {};

private _nvg = hmd _unit;
if (_nvg isNotEqualTo "") then {
    _unit unlinkItem _nvg;
};

// Weapon lights and IR lasers sit in the accessory slot of the primary weapon.
private _accessory = (primaryWeaponItems _unit) param [1, ""];
if (_accessory isNotEqualTo "") then {
    _unit removePrimaryWeaponItem _accessory;
};

// AI aims with IR lasers regardless of whether a pointer is attached.
if (!isPlayer _unit) then {
    _unit disableAI "LIGHTS";
};

if (_permanent) exitWith {
    // The unit keeps the dead hardware only if it was never removed; the NVG
    // was unlinked into the inventory, so drop it for good.
    if (_nvg isNotEqualTo "") then {
        _unit removeItem _nvg;
    };
};

[{
    params ["_unit", "_nvg", "_accessory"];
    if (isNull _unit || {!alive _unit}) exitWith {};

    if (_nvg isNotEqualTo "") then {
        _unit linkItem _nvg;
    };
    if (_accessory isNotEqualTo "") then {
        _unit addPrimaryWeaponItem _accessory;
    };
    if (!isPlayer _unit) then {
        _unit enableAI "LIGHTS";
    };
}, [_unit, _nvg, _accessory], _duration] call CBA_fnc_waitAndExecute;
