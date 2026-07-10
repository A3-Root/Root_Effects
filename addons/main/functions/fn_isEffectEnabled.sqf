#include "..\script_component.hpp"

/*
 * Author: Root
 * Checks whether an effect may be used, combining the mod wide master switch
 * with the effect's own CBA enable setting. Unregistered keys count as
 * disabled.
 *
 * Arguments:
 * 0: Unique effect key used at registration <STRING>
 *
 * Return Value:
 * Effect is allowed <BOOL>
 *
 * Example:
 * ["volcano"] call root_effects_main_fnc_isEffectEnabled
 */

params [["_effectKey", "", [""]]];

if (!GVAR(enabled)) exitWith {false};

private _entry = GVAR(effectRegistry) getOrDefault [_effectKey, []];
if (_entry isEqualTo []) exitWith {false};

missionNamespace getVariable [_entry select 1, true]
