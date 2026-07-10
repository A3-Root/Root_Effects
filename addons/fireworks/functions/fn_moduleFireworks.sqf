#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the fireworks display. Opens the configuration
 * dialog on the curator's machine and asks the server to start a display at
 * the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_fireworks_fnc_moduleFireworks
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["fireworks"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleFireworks), [
    ["SLIDER", [LLSTRING(AttrDuration), LLSTRING(AttrDurationTooltip)], [10, 1800, 120, 0]],
    ["SLIDER", [LLSTRING(AttrRate), LLSTRING(AttrRateTooltip)], [1, 60, 12, 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [10, 500, 50, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrHeight), LLSTRING(AttrHeightTooltip)], [50, 500, 150, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrSounds), LLSTRING(AttrSoundsTooltip)], true]
], {
    params ["_results", "_pos"];
    _results params ["_duration", "_rate", "_radius", "_height", "_sounds"];

    [QGVAR(start), [_pos, _duration, _rate, _radius, _height, _sounds]] call CBA_fnc_serverEvent;
    [LLSTRING(Started)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(dialog)] call zen_dialog_fnc_create;
