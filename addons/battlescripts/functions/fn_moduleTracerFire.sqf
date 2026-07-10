#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the ambient tracer fire. Opens the
 * configuration dialog on the curator's machine and asks the server to start
 * a new tracer source at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_battlescripts_fnc_moduleTracerFire
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["tracers"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleTracers), [
    ["SLIDER:RADIUS", [LLSTRING(AttrTracersActDist), LLSTRING(AttrTracersActDistTooltip)], [1, 1000, 150, 0, _pos, [7, 120, 32, 1]]],
    ["COLOR", [LLSTRING(AttrTracersColor), LLSTRING(AttrTracersColorTooltip)], [1, 1, 1]]
], {
    params ["_results", "_pos"];
    _results params ["_activationDistance", "_color"];

    [QGVAR(startTracers), [_pos, _activationDistance, _color]] call CBA_fnc_serverEvent;
    [LLSTRING(TracersStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(tracersDialog)] call zen_dialog_fnc_create;
