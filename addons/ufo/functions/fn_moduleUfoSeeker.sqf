#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the UFO seeker effect. Opens the configuration
 * dialog on the curator's machine and asks the server to start the wandering
 * seeker light near players once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ufo_fnc_moduleUfoSeeker
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["ufoseeker"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleSeeker), [
    ["SLIDER", [LLSTRING(AttrSeekerFreq), LLSTRING(AttrSeekerFreqTooltip)], [10, 600, 30, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_frequency"];

    [QGVAR(startSeeker), [_pos, _frequency]] call CBA_fnc_serverEvent;
    [LLSTRING(SeekerStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(seekerDialog)] call zen_dialog_fnc_create;
