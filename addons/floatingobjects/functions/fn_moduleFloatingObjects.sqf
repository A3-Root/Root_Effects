#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Zeus module entry point for the floating objects gag. Requires the module
 * to be attached to an object; opens the configuration dialog on the
 * curator's machine and asks the server to animate that object once
 * confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_floatingobjects_fnc_moduleFloatingObjects
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
private _object = attachedTo _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["floatingobjects"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

if (isNull _object) exitWith {
    [LLSTRING(PlaceOnObject)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleFloating), [
    ["TOOLBOX:YESNO", [LLSTRING(AttrDamage), LLSTRING(AttrDamageTooltip)], true],
    ["TOOLBOX:YESNO", [LLSTRING(AttrSimulation), LLSTRING(AttrSimulationTooltip)], false],
    ["SLIDER", [LLSTRING(AttrElevation), LLSTRING(AttrElevationTooltip)], [0, 1000, 5, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrSlide), LLSTRING(AttrSlideTooltip)], false],
    ["SLIDER", [LLSTRING(AttrSlideVel), LLSTRING(AttrSlideVelTooltip)], [0, 5, 0.02, 2]],
    ["SLIDER", [LLSTRING(AttrSlideDist), LLSTRING(AttrSlideDistTooltip)], [0, 50, 5, 1]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrBounce), LLSTRING(AttrBounceTooltip)], false],
    ["SLIDER", [LLSTRING(AttrBounceSpeed), LLSTRING(AttrBounceSpeedTooltip)], [0, 10, 0.2, 1]],
    ["SLIDER", [LLSTRING(AttrBounceAlt), LLSTRING(AttrBounceAltTooltip)], [0, 100, 2, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrRot), LLSTRING(AttrRotTooltip)], true],
    ["TOOLBOX:YESNO", [LLSTRING(AttrRotCw), LLSTRING(AttrRotCwTooltip)], true],
    ["SLIDER", [LLSTRING(AttrRotVel), LLSTRING(AttrRotVelTooltip)], [0, 10, 1, 1]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrRoll), LLSTRING(AttrRollTooltip)], false],
    ["SLIDER", [LLSTRING(AttrRollVel), LLSTRING(AttrRollVelTooltip)], [0, 5, 0.5, 1]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrOrbit), LLSTRING(AttrOrbitTooltip)], false],
    ["TOOLBOX:YESNO", [LLSTRING(AttrOrbitCw), LLSTRING(AttrOrbitCwTooltip)], true],
    ["SLIDER:RADIUS", [LLSTRING(AttrOrbitRadius), LLSTRING(AttrOrbitRadiusTooltip)], [5, 500, 10, 0, _pos, [7, 120, 32, 1]]],
    ["SLIDER", [LLSTRING(AttrOrbitSpeed), LLSTRING(AttrOrbitSpeedTooltip)], [0, 5, 0.1, 2]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrDistDependent), LLSTRING(AttrDistDependentTooltip)], false],
    ["SLIDER:RADIUS", [LLSTRING(AttrActDist), LLSTRING(AttrActDistTooltip)], [1, 5000, 500, 0, _pos, [7, 120, 32, 1]]]
], {
    params ["_results", "_object"];
    _results params ["_allowDamage", "_allowSimulation", "_elevation", "_slide", "_slideVel", "_slideDist", "_bounce", "_bounceSpeed", "_bounceAlt", "_rot", "_rotCw", "_rotVel", "_roll", "_rollVel", "_orbit", "_orbitCw", "_orbitRadius", "_orbitSpeed", "_distDependent", "_actDist"];

    if (!_slide) then {
        _slideVel = 0;
    };
    if (!_bounce) then {
        _bounceSpeed = 0;
    };
    if (!_rot) then {
        _rotVel = 0;
    };
    if (!_roll) then {
        _rollVel = 0;
    };
    if (!_orbit) then {
        _orbitRadius = 0;
    };
    if (!_distDependent) then {
        _actDist = 9999;
    };

    [QGVAR(start), [_object, _elevation, _allowDamage, _allowSimulation, [_slideVel, _slideDist], [_bounceSpeed, _bounceAlt], [_rotVel, _rotCw], _rollVel, [_orbitRadius, _orbitSpeed, _orbitCw], _actDist]] call CBA_fnc_serverEvent;
    [LLSTRING(Configured)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _object, QGVAR(dialog)] call zen_dialog_fnc_create;
