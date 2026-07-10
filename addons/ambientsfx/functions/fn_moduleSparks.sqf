#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the ambient sparks. Opens the configuration
 * dialog on the curator's machine and asks the server to start electrical
 * sparks at the module position (or attached object) once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ambientsfx_fnc_moduleSparks
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["sparks"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleSparks), [
    ["SLIDER", [LLSTRING(AttrSparksAltitude), LLSTRING(AttrSparksAltitudeTooltip)], [0, 100, 0, 0]],
    ["SLIDER", [LLSTRING(AttrSparksDelay), LLSTRING(AttrSparksDelayTooltip)], [1, 100, 10, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_altitude", "_sparkDelay"];

    [QGVAR(startSparks), [_pos, _altitude, _sparkDelay]] call CBA_fnc_serverEvent;
    [LLSTRING(SparksStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(sparksDialog)] call zen_dialog_fnc_create;
