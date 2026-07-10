#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the effect termination module. Requests a
 * snapshot of running effect instances from the server; the reply opens the
 * termination dialog on this machine.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_main_fnc_moduleTerminate
 */

params [["_logic", objNull, [objNull]]];

deleteVehicle _logic;

if (!hasInterface) exitWith {};

[QGVAR(requestInstances), [player]] call CBA_fnc_serverEvent;
