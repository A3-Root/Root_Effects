#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the volcano effect. Opens the configuration
 * dialog on the curator's machine and asks the server to start a new volcano
 * instance at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_volcano_fnc_moduleVolcano
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["volcano"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleVolcano), [
    ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [50, 500, 120, 0, _pos, [7, 120, 32, 1]]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrEruption), LLSTRING(AttrEruptionTooltip)], false],
    ["SLIDER", [LLSTRING(AttrDelay), LLSTRING(AttrDelayTooltip)], [30, 600, 300, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrCraterLava), LLSTRING(AttrCraterLavaTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLightning), LLSTRING(AttrLightningTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLavaFlow), LLSTRING(AttrLavaFlowTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLethal), LLSTRING(AttrLethalTooltip)], true],
    ["EDIT:MULTI", [LLSTRING(AttrGear), LLSTRING(AttrGearTooltip)], ["", {}, 4]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_enableEruption", "_eruptionDelay", "_craterLava", "_lightning", "_lavaFlow", "_lethal", "_gearText"];

    if (!_enableEruption) then {
        _eruptionDelay = 0;
    };

    [QGVAR(start), [_pos, _radius, _eruptionDelay, _craterLava, _lightning, _lavaFlow, _lethal, _gearText]] call CBA_fnc_serverEvent;
    [LLSTRING(Configured)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(dialog)] call zen_dialog_fnc_create;
