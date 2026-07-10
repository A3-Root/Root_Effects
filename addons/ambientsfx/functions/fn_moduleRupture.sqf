#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the spacetime rupture. Opens the configuration
 * dialog on the curator's machine and asks the server to start a rupture
 * above the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ambientsfx_fnc_moduleRupture
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["rupture"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleRupture), [
    ["SLIDER", [LLSTRING(AttrRuptureAltitude), LLSTRING(AttrRuptureAltitudeTooltip)], [1, 4000, 500, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_altitude"];

    [QGVAR(startRupture), [_pos, _altitude]] call CBA_fnc_serverEvent;
    [LLSTRING(RuptureStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(ruptureDialog)] call zen_dialog_fnc_create;
