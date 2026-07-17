#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the cryogenic blast. Opens the configuration
 * dialog on the curator's machine and asks the server to detonate the blast at
 * the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_freeze_fnc_moduleCryoBlast
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["cryoblast"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleCryo), [
    ["SLIDER:RADIUS", [LLSTRING(AttrCryoRadius), LLSTRING(AttrCryoRadiusTooltip)], [10, 500, 80, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrCryoDuration), LLSTRING(AttrCryoDurationTooltip)], [5, 600, 30, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrCryoCore), LLSTRING(AttrCryoCoreTooltip)], true]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_duration", "_lethalCore"];

    [QGVAR(startCryo), [_pos, _radius, _duration, _lethalCore]] call CBA_fnc_serverEvent;
    [LLSTRING(CryoStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(cryoDialog)] call zen_dialog_fnc_create;
