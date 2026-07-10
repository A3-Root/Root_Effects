#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the acid rain. Opens the configuration dialog
 * on the curator's machine and asks the server to start acid rain around the
 * module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_weather_fnc_moduleAcidRain
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["acidrain"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleAcidRain), [
    ["SLIDER:RADIUS", [LLSTRING(AttrAcidRadius), LLSTRING(AttrAcidRadiusTooltip)], [100, 5000, 500, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER:PERCENT", [LLSTRING(AttrAcidTint), LLSTRING(AttrAcidTintTooltip)], [0, 1, 0.5, 2]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrAcidDamage), LLSTRING(AttrAcidDamageTooltip)], true],
    ["SLIDER:PERCENT", [LLSTRING(AttrAcidDps), LLSTRING(AttrAcidDpsTooltip)], [0.01, 0.5, 0.05, 2]],
    ["SLIDER", [LLSTRING(AttrAcidTick), LLSTRING(AttrAcidTickTooltip)], [1, 60, 5, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_tint", "_damage", "_damagePerTick", "_tick"];

    [QGVAR(startAcidRain), [_pos, _radius, _tint, _damage, _damagePerTick, _tick]] call CBA_fnc_serverEvent;
    [LLSTRING(AcidRainStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(acidRainDialog)] call zen_dialog_fnc_create;
