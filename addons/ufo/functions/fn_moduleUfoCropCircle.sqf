#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the UFO crop circle effect. Opens the
 * configuration dialog on the curator's machine and asks the server to burn
 * a crop circle at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ufo_fnc_moduleUfoCropCircle
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["cropcircle"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleCropCircle), [
    ["SLIDER:RADIUS", [LLSTRING(AttrCropRadius), LLSTRING(AttrCropRadiusTooltip)], [20, 1000, 50, 0, _pos, [7, 120, 32, 1]]],
    ["COMBO", [LLSTRING(AttrCropType), LLSTRING(AttrCropTypeTooltip)], [["circle", "spiral", "flower"], [LLSTRING(CropTypeCircle), LLSTRING(CropTypeSpiral), LLSTRING(CropTypeFlower)], 0]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_cropType"];

    [QGVAR(startCropCircle), [_pos, _radius, _cropType]] call CBA_fnc_serverEvent;
    [LLSTRING(CropCircleStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(cropCircleDialog)] call zen_dialog_fnc_create;
