#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the EMP pulse. Opens the configuration dialog
 * on the curator's machine and asks the server to detonate the pulse at the
 * module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_emp_fnc_moduleEmp
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["emp"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleEmp), [
    ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [50, 2000, 300, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrDuration), LLSTRING(AttrDurationTooltip)], [5, 120, 20, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrKillEngines), LLSTRING(AttrKillEnginesTooltip)], true],
    ["SLIDER:PERCENT", [LLSTRING(AttrFuelDrain), LLSTRING(AttrFuelDrainTooltip)], [0, 1, 0, 2]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrHud), LLSTRING(AttrHudTooltip)], true],
    ["TOOLBOX:YESNO", [LLSTRING(AttrElectronics), LLSTRING(AttrElectronicsTooltip)], true],
    ["TOOLBOX:YESNO", [LLSTRING(AttrPermanent), LLSTRING(AttrPermanentTooltip)], false]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_duration", "_killEngines", "_fuelDrain", "_hud", "_electronics", "_permanent"];

    [QGVAR(start), [_pos, _radius, _duration, _killEngines, _fuelDrain, _hud, _electronics, _permanent]] call CBA_fnc_serverEvent;
    [LLSTRING(Started)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(dialog)] call zen_dialog_fnc_create;
