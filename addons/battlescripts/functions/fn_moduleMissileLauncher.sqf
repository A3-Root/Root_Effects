#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the ambient missile launcher. Opens the
 * configuration dialog on the curator's machine and asks the server to start
 * a new launcher instance at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_battlescripts_fnc_moduleMissileLauncher
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["missiles"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleMissiles), [
    ["SLIDER:RADIUS", [LLSTRING(AttrMissilesSafeDist), LLSTRING(AttrMissilesSafeDistTooltip)], [1, 1000, 25, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrMissilesDelay), LLSTRING(AttrMissilesDelayTooltip)], [1, 100, 10, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_safeDistance", "_launchDelay"];

    [QGVAR(startMissiles), [_pos, _safeDistance, _launchDelay]] call CBA_fnc_serverEvent;
    [LLSTRING(MissilesStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(missilesDialog)] call zen_dialog_fnc_create;
