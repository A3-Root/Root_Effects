#include "..\script_component.hpp"

/*
 * Author: Root, based on work by johnb43
 * Zeus module entry point for freezing and unfreezing players. Opens the
 * configuration dialog on the curator's machine, resolves the selected
 * sides, groups and units to player objects and asks the server to apply
 * the freeze state.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_freeze_fnc_moduleFreezePlayers
 */

params [["_logic", objNull, [objNull]]];

deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["freeze"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleFreeze), [
    ["TOOLBOX:YESNO", [LLSTRING(AttrFreeze), LLSTRING(AttrFreezeTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrUseAnim), LLSTRING(AttrUseAnimTooltip)], false],
    ["EDIT", [LLSTRING(AttrAnim), LLSTRING(AttrAnimTooltip)], ["HubSpectator_stand"]],
    ["OWNERS", [LLSTRING(AttrTargets), LLSTRING(AttrTargetsTooltip)], [[], [], [], 0], true]
], {
    params ["_results"];
    _results params ["_freeze", "_useAnim", "_animation", "_selected"];
    _selected params ["_sides", "_groups", "_players"];

    if (_sides isEqualTo [] && {_groups isEqualTo []} && {_players isEqualTo []}) exitWith {
        [LLSTRING(NoSelection)] call zen_common_fnc_showMessage;
    };

    private _targets = (call CBA_fnc_players) select {
        !(_x isKindOf "VirtualMan_F")
        && {(side _x) in _sides || {(group _x) in _groups} || {_x in _players}}
    };

    [QGVAR(apply), [_targets, _freeze, _useAnim, _animation]] call CBA_fnc_serverEvent;
    [format [[LLSTRING(UnfrozeCount), LLSTRING(FrozeCount)] select _freeze, count _targets]] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [], QGVAR(dialog)] call zen_dialog_fnc_create;
