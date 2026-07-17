#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the anti air barrage. Opens the configuration
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
 * [_logic] call root_effects_battlescripts_fnc_moduleAntiAirBarrage
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["aaa"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleAAA), [
    ["SLIDER:RADIUS", [LLSTRING(AttrAaaRadius), LLSTRING(AttrAaaRadiusTooltip)], [100, 5000, 500, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrAaaAltitude), LLSTRING(AttrAaaAltitudeTooltip)], [5, 1000, 150, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrAaaLethal), LLSTRING(AttrAaaLethalTooltip)], true],
    ["SLIDER:PERCENT", [LLSTRING(AttrAaaDmgAir), LLSTRING(AttrAaaDmgAirTooltip)], [0.01, 1, 0.05, 2]],
    ["SLIDER:PERCENT", [LLSTRING(AttrAaaDmgInf), LLSTRING(AttrAaaDmgInfTooltip)], [0.01, 1, 0.2, 2]],
    ["SLIDER", [LLSTRING(AttrAaaDelay), LLSTRING(AttrAaaDelayTooltip)], [0.5, 10, 1, 1]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrAaaSmokeOnly), LLSTRING(AttrAaaSmokeOnlyTooltip)], false],
    ["SLIDER:PERCENT", [LLSTRING(AttrAaaSpread), LLSTRING(AttrAaaSpreadTooltip)], [0.1, 1, 1, 2]],
    ["SLIDER", [LLSTRING(AttrAaaFireRate), LLSTRING(AttrAaaFireRateTooltip)], [1, 8, 1, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_altitude", "_lethal", "_damageAir", "_damageInf", "_burstDelay", "_smokeOnly", "_spread", "_fireRate"];

    [QGVAR(startAAA), [_pos, _radius, _altitude, _lethal, _damageAir, _damageInf, _burstDelay, _smokeOnly, _spread, _fireRate]] call CBA_fnc_serverEvent;
    [LLSTRING(AaaStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(aaaDialog)] call zen_dialog_fnc_create;
