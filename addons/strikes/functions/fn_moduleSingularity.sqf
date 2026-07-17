#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the singularity strike. Opens the configuration
 * dialog on the curator's machine and asks the server to start the anomaly at
 * the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_strikes_fnc_moduleSingularity
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["singularity"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleSingularity), [
    ["SLIDER:RADIUS", [LLSTRING(AttrSingularityRadius), LLSTRING(AttrSingularityRadiusTooltip)], [50, 300, 120, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrSingularityCharge), LLSTRING(AttrSingularityChargeTooltip)], [2, 30, 6, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrSingularityLethal), LLSTRING(AttrSingularityLethalTooltip)], true]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_chargeTime", "_lethal"];

    [QGVAR(startSingularity), [_pos, _radius, _chargeTime, _lethal]] call CBA_fnc_serverEvent;
    [LLSTRING(SingularityStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(singularityDialog)] call zen_dialog_fnc_create;
