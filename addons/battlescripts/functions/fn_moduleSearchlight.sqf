#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the sweeping searchlight. Opens the
 * configuration dialog on the curator's machine and asks the server to start
 * a new searchlight instance at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_battlescripts_fnc_moduleSearchlight
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["searchlight"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleSearchlight), [
    ["TOOLBOX:YESNO", [LLSTRING(AttrSearchlightAlarm), LLSTRING(AttrSearchlightAlarmTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrSearchlightAttach), LLSTRING(AttrSearchlightAttachTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrSearchlightAiSearch), LLSTRING(AttrSearchlightAiSearchTooltip)], true]
], {
    params ["_results", "_pos"];
    _results params ["_alarm", "_attach", "_aiSearch"];

    [QGVAR(startSearchlight), [_pos, _alarm, _attach, _aiSearch]] call CBA_fnc_serverEvent;
    [LLSTRING(SearchlightStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(searchlightDialog)] call zen_dialog_fnc_create;
