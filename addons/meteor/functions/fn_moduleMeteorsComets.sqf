#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the meteors and comets effect. Opens the
 * configuration dialog on the curator's machine and asks the server to start
 * the selected spawners once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_meteor_fnc_moduleMeteorsComets
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["meteors"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleMeteor), [
    ["TOOLBOX:YESNO", [LLSTRING(AttrMeteors), LLSTRING(AttrMeteorsTooltip)], false],
    ["SLIDER", [LLSTRING(AttrMeteorFreq), LLSTRING(AttrMeteorFreqTooltip)], [10, 600, 30, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrComets), LLSTRING(AttrCometsTooltip)], false],
    ["SLIDER", [LLSTRING(AttrCometFreq), LLSTRING(AttrCometFreqTooltip)], [10, 600, 30, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLethal), LLSTRING(AttrLethalTooltip)], true],
    ["TOOLBOX:YESNO", [LLSTRING(AttrStructureDamage), LLSTRING(AttrStructureDamageTooltip)], false],
    ["LIST", [LLSTRING(AttrTargetMode), LLSTRING(AttrTargetModeTooltip)], [[0, 1, 2], [LLSTRING(TargetModePlayers), LLSTRING(TargetModeArea), LLSTRING(TargetModeOwners)], 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrTargetRadius), LLSTRING(AttrTargetRadiusTooltip)], [50, 5000, 300, 0, _pos, [7, 120, 32, 1]]],
    ["OWNERS", [LLSTRING(AttrTargetOwners), LLSTRING(AttrTargetOwnersTooltip)], [[], [], []]]
], {
    params ["_results", "_pos"];
    _results params ["_meteors", "_meteorFreq", "_comets", "_cometFreq", "_lethal", "_structureDamage", "_targetMode", "_targetRadius", "_owners"];

    if (_meteors) then {
        [QGVAR(startMeteors), [_pos, _meteorFreq, _lethal, _targetMode, _targetRadius, _owners, _structureDamage]] call CBA_fnc_serverEvent;
    };
    if (_comets) then {
        [QGVAR(startComets), [_pos, _cometFreq, _targetMode, _targetRadius, _owners]] call CBA_fnc_serverEvent;
    };

    [LLSTRING(Configured)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(dialog)] call zen_dialog_fnc_create;
