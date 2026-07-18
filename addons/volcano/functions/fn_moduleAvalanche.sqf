#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the scree avalanche. Opens the configuration
 * dialog on the curator's machine and asks the server to start the slide at
 * the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_volcano_fnc_moduleAvalanche
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["avalanche"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleAvalanche), [
    ["TOOLBOX:YESNO", [LLSTRING(AttrAvalancheDownhill), LLSTRING(AttrAvalancheDownhillTooltip)], true],
    ["SLIDER", [LLSTRING(AttrAvalancheHeading), LLSTRING(AttrAvalancheHeadingTooltip)], [0, 360, 0, 0]],
    ["SLIDER", [LLSTRING(AttrAvalancheLength), LLSTRING(AttrAvalancheLengthTooltip)], [50, 800, 200, 0]],
    ["SLIDER", [LLSTRING(AttrAvalancheDuration), LLSTRING(AttrAvalancheDurationTooltip)], [10, 300, 25, 0]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrAvalancheLethal), LLSTRING(AttrAvalancheLethalTooltip)], true],
    ["EDIT", [LLSTRING(AttrAvalancheObjects), LLSTRING(AttrAvalancheObjectsTooltip)], ""]
], {
    params ["_results", "_pos"];
    _results params ["_downhill", "_heading", "_length", "_duration", "_lethal", "_objects"];

    // A negative heading tells the server to work the slope out for itself.
    if (_downhill) then {
        _heading = -1;
    };

    [QGVAR(startAvalanche), [_pos, _heading, _length, _duration, _lethal, _objects]] call CBA_fnc_serverEvent;
    [LLSTRING(AvalancheStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(avalancheDialog)] call zen_dialog_fnc_create;
