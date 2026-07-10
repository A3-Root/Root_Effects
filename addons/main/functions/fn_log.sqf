#include "..\script_component.hpp"

/*
 * Author: Root
 * Writes a component tagged line to the RPT when verbose debug logging is
 * enabled through the CBA settings. Usually invoked through the DBG macro.
 *
 * Arguments:
 * 0: Component name <STRING>
 * 1: Message <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["volcano", "eruption scheduled"] call root_effects_main_fnc_log
 */

params [["_component", "", [""]], ["_message", "", [""]]];

if (!(missionNamespace getVariable [QGVAR(debugLogging), false])) exitWith {};

diag_log text format ["[Root's Effects] (%1) %2", _component, _message];
