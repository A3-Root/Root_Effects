#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the lightning storm. Opens the configuration
 * dialog on the curator's machine and asks the server to start a storm
 * around the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_weather_fnc_moduleLightningStorm
 */

params [["_logic", objNull, [objNull]]];

DBG(FORMAT_3("moduleLightningStorm called with %1 by %2 at %3",_this,profileName,mapGridPosition (positionCameraToWorld [ARR_3(0,0,0)])));

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["lightningstorm"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleLightning), [
    ["SLIDER:RADIUS", [LLSTRING(AttrLightningRadius), LLSTRING(AttrLightningRadiusTooltip)], [50, 2000, 300, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrLightningDuration), LLSTRING(AttrLightningDurationTooltip)], [0, 3600, 300, 0]],
    ["SLIDER", [LLSTRING(AttrLightningMinInt), LLSTRING(AttrLightningMinIntTooltip)], [1, 120, 5, 0]],
    ["SLIDER", [LLSTRING(AttrLightningMaxInt), LLSTRING(AttrLightningMaxIntTooltip)], [1, 300, 20, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLightningDamage), LLSTRING(AttrLightningDamageTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrLightningAmbience), LLSTRING(AttrLightningAmbienceTooltip)], true],
    ["SLIDER:PERCENT", [LLSTRING(AttrLightningStrength), LLSTRING(AttrLightningStrengthTooltip)], [0, 1, 0.7, 0]],
    ["CHECKBOX", [LLSTRING(AttrTornado), LLSTRING(AttrTornadoTooltip)], false],
    ["SLIDER", [LLSTRING(AttrTornadoSize), LLSTRING(AttrTornadoSizeTooltip)], [50, 300, 120, 0]],
    ["SLIDER", [LLSTRING(AttrTornadoSpeed), LLSTRING(AttrTornadoSpeedTooltip)], [1, 40, 8, 0]],
    ["CHECKBOX", [LLSTRING(AttrTornadoFling), LLSTRING(AttrTornadoFlingTooltip)], false]
], {
    params ["_results", "_pos"];
    _results params ["_radius", "_duration", "_minInterval", "_maxInterval", "_damage", "_ambience", "_strength", "_tornado", "_tornadoSize", "_tornadoSpeed", "_tornadoFling"];

    [QGVAR(startLightning), [_pos, _radius, _duration, _minInterval, _maxInterval, _damage, _ambience, _strength, _tornado, _tornadoSize, _tornadoSpeed, _tornadoFling]] call EFUNC(main,serverEventLogged);
    DBG(FORMAT_4("lightning storm requested by %1 at %2 (radius %3, tornado %4)",profileName,mapGridPosition _pos,_radius,_tornado));
    [LLSTRING(LightningStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(lightningDialog)] call zen_dialog_fnc_create;
