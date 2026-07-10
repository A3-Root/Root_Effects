#include "..\script_component.hpp"

/*
 * Author: Root
 * Registers an effect module with the shared registry so the termination
 * module can list and stop its running instances. Called once per effect
 * from the owning addon's preInit on every machine.
 *
 * Arguments:
 * 0: Unique effect key <STRING>
 * 1: Human readable effect name <STRING>
 * 2: Name of the CBA setting variable that enables this effect <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["volcano", "Volcano Eruption", "root_effects_volcano_enabledVolcano"] call root_effects_main_fnc_registerEffect
 */

params [["_effectKey", "", [""]], ["_displayName", "", [""]], ["_settingVar", "", [""]]];

if (_effectKey isEqualTo "") exitWith {};

GVAR(effectRegistry) set [_effectKey, [_displayName, _settingVar]];
