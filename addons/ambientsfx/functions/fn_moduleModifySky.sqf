#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module: changes the aurora or spacetime rupture closest to where it is
 * placed, live. The dialog starts from the effect's current settings.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ambientsfx_fnc_moduleModifySky
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

private _anchors = (nearestObjects [[_pos select 0, _pos select 1, 0], [ANCHOR_CLASS], 8000]) select {
    (_x getVariable [QEGVAR(main,effectKey), ""]) in ["aurora", "rupture"]
};
if (_anchors isEqualTo []) exitWith {
    [LLSTRING(NoSkyEffect)] call zen_common_fnc_showMessage;
};
private _anchor = _anchors select 0;

(_anchor getVariable [QGVAR(skyCfg), [true, true, 1, 1, 0, 0]]) params ["_spawn", "_despawn", "_sizeScale", "_lengthScale"];
(_anchor getVariable [QGVAR(skyCtl), [0, 0, 0, 0]]) params ["_switch", "_shape", "_speed", "_mode"];
private _frozen = !_spawn && !_despawn;

[format [LLSTRING(ModuleModifySkyTitle), _anchor getVariable [QEGVAR(main,effectKey), ""], mapGridPosition _anchor], [
    ["CHECKBOX", [LLSTRING(AttrSkyModFreeze), LLSTRING(AttrSkyModFreezeTooltip)], _frozen],
    ["CHECKBOX", [LLSTRING(AttrSkyModSpawn), LLSTRING(AttrSkyModSpawnTooltip)], _spawn],
    ["CHECKBOX", [LLSTRING(AttrSkyModDespawn), LLSTRING(AttrSkyModDespawnTooltip)], _despawn],
    ["SLIDER", [LLSTRING(AttrSkySize), LLSTRING(AttrSkySizeTooltip)], [0.3, 3, _sizeScale, 1]],
    ["SLIDER", [LLSTRING(AttrSkyLength), LLSTRING(AttrSkyLengthTooltip)], [0.3, 3, _lengthScale, 1]],
    ["COMBO", [LLSTRING(AttrSkyShape), LLSTRING(AttrSkyShapeTooltip)], [[0, 1, 2, 3, 4, 5], [LLSTRING(ShapeBand), LLSTRING(ShapeArc), LLSTRING(ShapeWave), LLSTRING(ShapeRing), LLSTRING(ShapeSpiral), LLSTRING(ShapeRandom)], _shape]],
    ["SLIDER", [LLSTRING(AttrSkySwitch), LLSTRING(AttrSkySwitchTooltip)], [0, 900, _switch, 0]],
    ["SLIDER", [LLSTRING(AttrSkyMoveSpeed), LLSTRING(AttrSkyMoveSpeedTooltip)], [0, 50, _speed, 1]],
    ["COMBO", [LLSTRING(AttrSkyMoveMode), LLSTRING(AttrSkyMoveModeTooltip)], [[0, 1], [LLSTRING(MoveDrift), LLSTRING(MoveWander)], _mode]]
], {
    params ["_results", "_anchor"];
    if (isNull _anchor) exitWith {
        [LLSTRING(NoSkyEffect)] call zen_common_fnc_showMessage;
    };
    [QGVAR(modifySky), [_anchor] + _results] call EFUNC(main,serverEventLogged);
    DBG(FORMAT_3("sky modify requested by %1 for %2: %3",profileName,mapGridPosition _anchor,_results));
    [LLSTRING(SkyModified)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _anchor, QGVAR(modifySkyDialog)] call zen_dialog_fnc_create;
