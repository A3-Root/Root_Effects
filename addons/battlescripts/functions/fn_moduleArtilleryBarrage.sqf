#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the artillery barrage. Opens the configuration
 * dialog on the curator's machine and asks the server to start a new barrage
 * instance at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_battlescripts_fnc_moduleArtilleryBarrage
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["artillery"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleArtillery), [
    ["SLIDER:RADIUS", [LLSTRING(AttrArtyRadius), LLSTRING(AttrArtyRadiusTooltip)], [100, 5000, 500, 0, _pos, [7, 120, 32, 1]]],
    ["LIST", [LLSTRING(AttrArtyMode), LLSTRING(AttrArtyModeTooltip)], [[0, 1, 2], [LLSTRING(ArtyModeLethal), LLSTRING(ArtyModeNonLethal), LLSTRING(ArtyModeSoundOnly)], 0, 3]],
    ["LIST", [LLSTRING(AttrArtyShell), LLSTRING(AttrArtyShellTooltip)], [
        ["G_40mm_HE", "M_Mo_82mm_AT_LG", "Sh_120mm_APFSDS", "Sh_120mm_HE", "Sh_155mm_AMOS", "HelicopterExploSmall", "HelicopterExploBig", "Bo_GBU12_LGB", "Bo_GBU12_LGB_MI10"],
        [LLSTRING(ArtyShell40mm), LLSTRING(ArtyShell82mm), LLSTRING(ArtyShell120sabot), LLSTRING(ArtyShell120he), LLSTRING(ArtyShell155he), LLSTRING(ArtyShellHeliSmall), LLSTRING(ArtyShellHeliBig), LLSTRING(ArtyShellGbu1), LLSTRING(ArtyShellGbu2)],
        4, 10
    ]],
    ["SLIDER", [LLSTRING(AttrArtyDelay), LLSTRING(AttrArtyDelayTooltip)], [1, 20, 3, 1]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_mode", "_shellClass", "_fireDelay"];

    [QGVAR(startArtillery), [_pos, _radius, _mode, _shellClass, _fireDelay]] call CBA_fnc_serverEvent;
    [LLSTRING(ArtilleryStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(artilleryDialog)] call zen_dialog_fnc_create;
