#include "..\script_component.hpp"

/*
 * Author: Root
 * Creates a post process effect at the first free priority from the given one up.
 *
 * Arguments:
 * 0: Effect name <STRING>
 * 1: Starting priority <NUMBER>
 *
 * Return Value:
 * Effect handle, -1 when none was free <NUMBER>
 *
 * Example:
 * ["FilmGrain", 2010] call root_effects_main_fnc_ppCreate
 */

params [["_name", "", [""]], ["_priority", 0, [0]]];

private _handle = -1;
for "_i" from 0 to 99 do {
    _handle = ppEffectCreate [_name, _priority + _i];
    if (_handle != -1) exitWith {};
};
_handle
