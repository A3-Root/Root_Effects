#include "..\script_component.hpp"

/*
 * Author: Root, based on community carpet strike scripts by DCON and M9SD
 * Zeus module entry point for the carpet bombing strike. Opens the
 * configuration dialog on the curator's machine and asks the server to run
 * the bombing run over the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_strikes_fnc_moduleCarpetStrike
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["carpetstrike"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleCarpet), [
    ["EDIT", [LLSTRING(AttrCarpetPlane), LLSTRING(AttrCarpetPlaneTooltip)], ["B_Plane_CAS_01_dynamicLoadout_F"]],
    ["SLIDER", [LLSTRING(AttrCarpetPlanes), LLSTRING(AttrCarpetPlanesTooltip)], [1, 4, 1, 0]],
    ["EDIT", [LLSTRING(AttrCarpetBomb), LLSTRING(AttrCarpetBombTooltip)], ["Bo_Mk82"]],
    ["SLIDER", [LLSTRING(AttrCarpetHeading), LLSTRING(AttrCarpetHeadingTooltip)], [0, 360, 0, 0]],
    ["SLIDER", [LLSTRING(AttrCarpetCount), LLSTRING(AttrCarpetCountTooltip)], [1, 500, 50, 0]],
    ["SLIDER", [LLSTRING(AttrCarpetLength), LLSTRING(AttrCarpetLengthTooltip)], [50, 1000, 150, 0]],
    ["SLIDER", [LLSTRING(AttrCarpetDelay), LLSTRING(AttrCarpetDelayTooltip)], [10, 60, 35, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_planeClass", "_planeCount", "_bombClass", "_heading", "_bombCount", "_length", "_dropDelay"];

    [QGVAR(startCarpet), [_pos, _planeClass, _planeCount, _bombClass, _heading, _bombCount, _length, _dropDelay]] call CBA_fnc_serverEvent;
    [LLSTRING(CarpetStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(carpetDialog)] call zen_dialog_fnc_create;
