#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for stopping every running feed. Asks for a simple
 * confirmation, then tells the server to stop them all.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_dronefeed_fnc_moduleKillAll
 */

params [["_logic", objNull, [objNull]]];

deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["dronefeed"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleKillAll), [
    ["TOOLBOX:YESNO", [LLSTRING(ConfirmKillAll), LLSTRING(ConfirmKillAllTooltip)], false]
], {
    params ["_results"];
    _results params ["_confirm"];
    if (!_confirm) exitWith {};
    [QGVAR(requestKillAll), []] call CBA_fnc_serverEvent;
    [LLSTRING(FeedsStopped)] call zen_common_fnc_showMessage;
}, {}, [], QGVAR(killAllDialog)] call zen_dialog_fnc_create;
