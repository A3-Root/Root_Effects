#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the UFO encounter effect. Opens the
 * configuration dialog on the curator's machine and asks the server to start
 * random UFO sightings near players once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ufo_fnc_moduleUfoEncounter
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["ufoencounter"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleEncounter), [
    ["SLIDER", [LLSTRING(AttrEncounterFreq), LLSTRING(AttrEncounterFreqTooltip)], [10, 600, 30, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_frequency"];

    [QGVAR(startEncounter), [_pos, _frequency]] call CBA_fnc_serverEvent;
    [LLSTRING(EncounterStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(encounterDialog)] call zen_dialog_fnc_create;
