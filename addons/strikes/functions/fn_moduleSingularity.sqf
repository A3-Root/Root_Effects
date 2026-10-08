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

DBG(FORMAT_3("moduleSingularity called with %1 by %2 at %3",_this,profileName,mapGridPosition (positionCameraToWorld [ARR_3(0,0,0)])));

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["singularity"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleSingularity), [
    ["SLIDER:RADIUS", [LLSTRING(AttrSingularityRadius), LLSTRING(AttrSingularityRadiusTooltip)], [50, 300, 120, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrSingularityCharge), LLSTRING(AttrSingularityChargeTooltip)], [SINGULARITY_MIN_CHARGE, 40, 8, 1]],
    ["SLIDER:PERCENT", [LLSTRING(AttrSingularityLethal), LLSTRING(AttrSingularityLethalTooltip)], [0, 1, 1, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_chargeTime", "_lethal"];

    [QGVAR(startSingularity), [_pos, _radius, _chargeTime, _lethal]] call EFUNC(main,serverEventLogged);
    DBG(FORMAT_4("singularity requested by %1 at %2 (radius %3, damage %4)",profileName,mapGridPosition _pos,_radius,_lethal));
    [LLSTRING(SingularityStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(singularityDialog)] call zen_dialog_fnc_create;
