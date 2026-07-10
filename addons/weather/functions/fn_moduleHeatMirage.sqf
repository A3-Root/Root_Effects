#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the heat mirage. Opens the configuration
 * dialog on the curator's machine and asks the server to start a shimmering
 * heat haze zone around the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_weather_fnc_moduleHeatMirage
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["heatmirage"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleMirage), [
    ["SLIDER:RADIUS", [LLSTRING(AttrMirageRadius), LLSTRING(AttrMirageRadiusTooltip)], [20, 2000, 200, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER:PERCENT", [LLSTRING(AttrMirageIntensity), LLSTRING(AttrMirageIntensityTooltip)], [0.1, 1, 0.5, 2]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_intensity"];

    [QGVAR(startMirage), [_pos, _radius, _intensity]] call CBA_fnc_serverEvent;
    [LLSTRING(MirageStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(mirageDialog)] call zen_dialog_fnc_create;
