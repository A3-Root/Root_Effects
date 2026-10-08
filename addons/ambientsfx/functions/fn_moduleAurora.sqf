#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the aurora borealis. Opens the configuration
 * dialog on the curator's machine and asks the server to start an aurora
 * above the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ambientsfx_fnc_moduleAurora
 */

params [["_logic", objNull, [objNull]]];

DBG(FORMAT_3("moduleAurora called with %1 by %2 at %3",_this,profileName,mapGridPosition (positionCameraToWorld [ARR_3(0,0,0)])));

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["aurora"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleAurora), [
    ["SLIDER", [LLSTRING(AttrAuroraAltitude), LLSTRING(AttrAuroraAltitudeTooltip)], [1, 4000, 500, 0]],
    ["COMBO", [LLSTRING(AttrSkyShape), LLSTRING(AttrSkyShapeTooltip)], [[0, 1, 2, 3, 4, 5], [LLSTRING(ShapeBand), LLSTRING(ShapeArc), LLSTRING(ShapeWave), LLSTRING(ShapeRing), LLSTRING(ShapeSpiral), LLSTRING(ShapeRandom)], 0]],
    ["SLIDER", [LLSTRING(AttrSkyFadeIn), LLSTRING(AttrSkyFadeInTooltip)], [0.5, 120, 20, 1]],
    ["SLIDER", [LLSTRING(AttrSkyFadeOut), LLSTRING(AttrSkyFadeOutTooltip)], [0.5, 120, 20, 1]],
    ["SLIDER", [LLSTRING(AttrSkyLifetime), LLSTRING(AttrSkyLifetimeTooltip)], [5, 600, 180, 0]],
    ["SLIDER:PERCENT", [LLSTRING(AttrSkyDensity), LLSTRING(AttrSkyDensityTooltip)], [0.1, 1, 0.5, 0]],
    ["SLIDER", [LLSTRING(AttrSkySize), LLSTRING(AttrSkySizeTooltip)], [0.3, 3, 1, 1]],
    ["SLIDER", [LLSTRING(AttrSkyLength), LLSTRING(AttrSkyLengthTooltip)], [0.3, 3, 1, 1]],
    ["SLIDER", [LLSTRING(AttrSkySwitch), LLSTRING(AttrSkySwitchTooltip)], [0, 900, 0, 0]]
], {
    params ["_results", "_pos"];
    _results params ["_altitude", "_shape", "_fadeIn", "_fadeOut", "_lifetime", "_density", "_sizeScale", "_lengthScale", "_switchInterval"];

    [QGVAR(startAurora), [_pos, _altitude, _shape, _fadeIn, _fadeOut, _lifetime, _density, false, _sizeScale, _lengthScale, _switchInterval]] call EFUNC(main,serverEventLogged);
    DBG(FORMAT_3("aurora requested by %1 at %2, shape %3",profileName,mapGridPosition _pos,_shape));
    [LLSTRING(AuroraStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(auroraDialog)] call zen_dialog_fnc_create;
