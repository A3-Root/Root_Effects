#include "..\script_component.hpp"

/*
 * Author: Root
 * Adds damage to every hitpoint of a vehicle on the machine where it is local.
 * Aircraft in particular only lose control surfaces and take visible damage
 * when their hitpoints are hit, plain setDamage leaves them flying.
 *
 * Arguments:
 * 0: Vehicle to damage <OBJECT>
 * 1: Damage to add per hitpoint, 0..1 <NUMBER>
 * 2: Randomise the amount independently per hitpoint, drawing 0..arg1 <BOOL> (optional, default false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_heli, 0.2] call root_effects_main_fnc_doHitPointDamageLocal
 */

params [["_vehicle", objNull, [objNull]], ["_damage", 0, [0]], ["_randomize", false, [false]]];

if (isNull _vehicle || {!alive _vehicle} || {_damage <= 0}) exitWith {};

private _hitPoints = getAllHitPointsDamage _vehicle;
if (_hitPoints isEqualTo []) exitWith {};

_hitPoints params ["_hitPointNames", "", "_hitPointDamage"];

{
    // Some hitpoints share a selection and report an empty name; those cannot
    // be addressed individually and are skipped.
    if (_x isNotEqualTo "") then {
        // Each hitpoint can take an independent random amount so the wear reads
        // as an uneven spread of hits rather than a uniform knock across the frame.
        private _add = if (_randomize) then {random _damage} else {_damage};
        _vehicle setHitPointDamage [_x, (((_hitPointDamage select _forEachIndex) + _add) min 1), false];
    };
} forEach _hitPointNames;
