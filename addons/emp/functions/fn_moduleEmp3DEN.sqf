#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the EMP field. Runs when its trigger fires (or at
 * mission start without one). The field sits on the first synced object, or at
 * the module position.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Module activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call root_effects_emp_fnc_moduleEmp3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

DBG(FORMAT_1("moduleEmp3DEN called with %1",_this));

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","EMP",mapGridPosition _logic,allVariables _logic));

private _synced = (synchronizedObjects _logic) select {!(_x isKindOf "EmptyDetector") && {!(_x isKindOf "Logic")}};
private _target = if (_synced isEqualTo []) then {getPosATL _logic} else {_synced select 0};

private _d = call FUNC(empDefaults);
private _get = {
    params ["_attribute", "_key"];
    _logic getVariable [_attribute, _d get _key]
};

private _settings = [
    ["radius", ["ROOT_EMP_RADIUS", "radius"] call _get],
    ["altitude", ["ROOT_EMP_ALTITUDE", "altitude"] call _get],
    ["countdown", ["ROOT_EMP_COUNTDOWN", "countdown"] call _get],
    ["linger", ["ROOT_EMP_DURATION", "linger"] call _get],
    ["shockSpeed", ["ROOT_EMP_SHOCKSPEED", "shockSpeed"] call _get],
    ["effectDelay", ["ROOT_EMP_EFFECTDELAY", "effectDelay"] call _get],
    ["vehicles", ["ROOT_EMP_VEHICLES", "vehicles"] call _get],
    ["aircraft", ["ROOT_EMP_AIRCRAFT", "aircraft"] call _get],
    ["uavs", ["ROOT_EMP_UAVS", "uavs"] call _get],
    ["lamps", ["ROOT_EMP_LAMPS", "lamps"] call _get],
    ["gear", ["ROOT_EMP_GEAR", "gear"] call _get],
    ["ai", ["ROOT_EMP_AI", "ai"] call _get],
    ["radios", ["ROOT_EMP_RADIOS", "radios"] call _get],
    ["channels", ["ROOT_EMP_CHANNELS", "channels"] call _get],
    ["fuelDrain", ["ROOT_EMP_FUELDRAIN", "fuelDrain"] call _get],
    ["restore", ["ROOT_EMP_RESTORE", "restore"] call _get],
    ["grace", ["ROOT_EMP_GRACE", "grace"] call _get],
    ["warnGround", ["ROOT_EMP_WARNGROUND", "warnGround"] call _get],
    ["warnHeli", ["ROOT_EMP_WARNHELI", "warnHeli"] call _get],
    ["warnPlane", ["ROOT_EMP_WARNPLANE", "warnPlane"] call _get],
    ["visuals", ["ROOT_EMP_VISUALS", "visuals"] call _get],
    ["chargeGlow", ["ROOT_EMP_CHARGEGLOW", "chargeGlow"] call _get],
    ["shake", ["ROOT_EMP_SHAKE", "shake"] call _get],
    ["hud", ["ROOT_EMP_HUD", "hud"] call _get],
    ["dome", ["ROOT_EMP_DOME", "dome"] call _get],
    ["domeColor", _logic getVariable ["ROOT_EMP_DOMECOLOR", "0.5,0.5,0.5"]],
    ["domeAlpha", ["ROOT_EMP_DOMEALPHA", "domeAlpha"] call _get],
    ["domeShimmer", ["ROOT_EMP_DOMESHIMMER", "domeShimmer"] call _get],
    ["domeLightning", ["ROOT_EMP_DOMELIGHTNING", "domeLightning"] call _get],
    ["domeMirage", ["ROOT_EMP_DOMEMIRAGE", "domeMirage"] call _get],
    ["fog", ["ROOT_EMP_FOG", "fog"] call _get],
    ["fogAlpha", ["ROOT_EMP_FOGALPHA", "fogAlpha"] call _get],
    ["flickerGear", ["ROOT_EMP_FLICKERGEAR", "flickerGear"] call _get],
    ["flickerVehicles", ["ROOT_EMP_FLICKERVEHICLES", "flickerVehicles"] call _get],
    ["flickerLamps", ["ROOT_EMP_FLICKERLAMPS", "flickerLamps"] call _get],
    ["marker", ["ROOT_EMP_MARKER", "marker"] call _get],
    ["markerSync", ["ROOT_EMP_MARKERSYNC", "markerSync"] call _get],
    ["beep", ["ROOT_EMP_BEEP", "beep"] call _get],
    ["timer3D", ["ROOT_EMP_TIMER3D", "timer3D"] call _get],
    ["timerHint", ["ROOT_EMP_TIMERHINT", "timerHint"] call _get],
    ["interaction", ["ROOT_EMP_INTERACTION", "interaction"] call _get],
    ["holdTime", ["ROOT_EMP_HOLDTIME", "holdTime"] call _get],
    ["requiredItem", ["ROOT_EMP_REQITEM", "requiredItem"] call _get],
    ["abortCountdown", ["ROOT_EMP_ABORT", "abortCountdown"] call _get],
    ["endOnDestroyed", ["ROOT_EMP_ENDDESTROYED", "endOnDestroyed"] call _get],
    ["itemsExtra", ["ROOT_EMP_ITEMSEXTRA", "itemsExtra"] call _get],
    ["itemsImmune", ["ROOT_EMP_ITEMSIMMUNE", "itemsImmune"] call _get],
    ["vehiclesImmune", ["ROOT_EMP_VEHIMMUNE", "vehiclesImmune"] call _get]
];

// Older attributes: permanent, engines and electronics switches.
if (_logic getVariable ["ROOT_EMP_PERMANENT", false]) then {_settings pushBack ["linger", -1]};
if !(_logic getVariable ["ROOT_EMP_KILLENGINES", true]) then {
    _settings append [["vehicles", 0], ["aircraft", 0], ["uavs", 0]];
};
if !(_logic getVariable ["ROOT_EMP_ELECTRONICS", true]) then {
    _settings append [["gear", 0], ["lamps", 0], ["ai", false], ["radios", false]];
};

deleteVehicle _logic;

[_target, _settings] call FUNC(create);
