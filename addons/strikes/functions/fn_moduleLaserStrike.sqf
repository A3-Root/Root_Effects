#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the orbital laser strike. Opens the
 * configuration dialog on the curator's machine and asks the server to fire
 * the laser at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_strikes_fnc_moduleLaserStrike
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["laserstrike"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleLaser), [
    ["SLIDER", [LLSTRING(AttrLaserCharge), LLSTRING(AttrLaserChargeTooltip)], [1, 30, 5, 0]],
    ["SLIDER", [LLSTRING(AttrLaserBeam), LLSTRING(AttrLaserBeamTooltip)], [1, 30, 3, 0]],
    ["COLOR", [LLSTRING(AttrLaserColor), LLSTRING(AttrLaserColorTooltip)], [1, 0.2, 0.2]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLaserDamage), LLSTRING(AttrLaserDamageTooltip)], true],
    ["SLIDER:RADIUS", [LLSTRING(AttrLaserDmgRadius), LLSTRING(AttrLaserDmgRadiusTooltip)], [5, 100, 30, 0, _pos, [7, 120, 32, 1]]]
], {
    params ["_results", "_pos"];
    _results params ["_chargeTime", "_beamTime", "_color", "_damage", "_damageRadius"];

    [QGVAR(startLaser), [_pos, _chargeTime, _beamTime, _color select [0, 3], _damage, _damageRadius]] call CBA_fnc_serverEvent;
    [LLSTRING(LaserStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(laserDialog)] call zen_dialog_fnc_create;
