#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the napalm strike. Opens the configuration
 * dialog on the curator's machine and asks the server to run the strike over
 * the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_strikes_fnc_moduleNapalmStrike
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["napalmstrike"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleNapalm), [
    ["EDIT", [LLSTRING(AttrNapalmPlane), LLSTRING(AttrNapalmPlaneTooltip)], ["B_Plane_CAS_01_dynamicLoadout_F"]],
    ["SLIDER", [LLSTRING(AttrNapalmHeading), LLSTRING(AttrNapalmHeadingTooltip)], [0, 360, 0, 0]],
    ["SLIDER", [LLSTRING(AttrNapalmLength), LLSTRING(AttrNapalmLengthTooltip)], [50, 500, 150, 0]],
    ["SLIDER", [LLSTRING(AttrNapalmDuration), LLSTRING(AttrNapalmDurationTooltip)], [15, 600, 180, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrNapalmDamage), LLSTRING(AttrNapalmDamageTooltip)], true],
    ["SLIDER", [LLSTRING(AttrNapalmDropDelay), LLSTRING(AttrNapalmDropDelayTooltip)], [5, 120, 20, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_planeClass", "_heading", "_length", "_duration", "_damage", "_dropDelay"];

    [QGVAR(startNapalm), [_pos, _planeClass, _heading, _length, _duration, _damage, _dropDelay]] call CBA_fnc_serverEvent;
    [LLSTRING(NapalmStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(napalmDialog)] call zen_dialog_fnc_create;
