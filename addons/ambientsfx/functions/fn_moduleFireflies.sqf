#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the ambient fireflies. Opens the configuration
 * dialog on the curator's machine and asks the server to start a firefly
 * swarm at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ambientsfx_fnc_moduleFireflies
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["fireflies"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleFireflies), [
    ["SLIDER", [LLSTRING(AttrFirefliesAltitude), LLSTRING(AttrFirefliesAltitudeTooltip)], [1, 100, 1, 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrFirefliesActDist), LLSTRING(AttrFirefliesActDistTooltip)], [10, 500, 100, 0, _pos, [7, 120, 32, 1]]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrFirefliesFrogs), LLSTRING(AttrFirefliesFrogsTooltip)], true]
], {
    params ["_results", "_pos"];
    _results params ["_altitude", "_activationDistance", "_frogs"];

    [QGVAR(startFireflies), [_pos, _altitude, _activationDistance, _frogs]] call CBA_fnc_serverEvent;
    [LLSTRING(FirefliesStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(firefliesDialog)] call zen_dialog_fnc_create;
