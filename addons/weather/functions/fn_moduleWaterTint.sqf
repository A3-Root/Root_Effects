#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the water tint. Opens the configuration dialog
 * on the curator's machine and asks the server to tint the water impression
 * around the module position once confirmed. For a true engine level water
 * recolor across the whole map, load the optional watercolor addon instead.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_weather_fnc_moduleWaterTint
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["watertint"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleWaterTint), [
    ["SLIDER:RADIUS", [LLSTRING(AttrTintRadius), LLSTRING(AttrTintRadiusTooltip)], [50, 5000, 500, 0, _pos, [7, 120, 32, 1]]],
    ["LIST", [LLSTRING(AttrTintColor), LLSTRING(AttrTintColorTooltip)], [[0, 1, 2], [LLSTRING(TintColorBlood), LLSTRING(TintColorToxic), LLSTRING(TintColorInk)], 0, 3]],
    ["SLIDER:PERCENT", [LLSTRING(AttrTintStrength), LLSTRING(AttrTintStrengthTooltip)], [0.1, 1, 0.6, 2]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_colorIndex", "_strength"];

    [QGVAR(startWaterTint), [_pos, _radius, _colorIndex, _strength]] call CBA_fnc_serverEvent;
    [LLSTRING(WaterTintStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(waterTintDialog)] call zen_dialog_fnc_create;
