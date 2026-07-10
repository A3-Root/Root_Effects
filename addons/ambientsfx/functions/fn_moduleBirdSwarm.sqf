#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the ambient bird swarm. Opens the
 * configuration dialog on the curator's machine and asks the server to start
 * a flock of birds circling the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_ambientsfx_fnc_moduleBirdSwarm
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["birdswarm"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleBirdSwarm), [
    ["SLIDER", [LLSTRING(AttrBirdCount), LLSTRING(AttrBirdCountTooltip)], [1, 60, 15, 0]],
    ["SLIDER:RADIUS", [LLSTRING(AttrBirdRadius), LLSTRING(AttrBirdRadiusTooltip)], [50, 1000, 150, 0, _pos, [7, 120, 32, 1]]]
], {
    params ["_results", "_pos"];
    _results params ["_count", "_radius"];

    [QGVAR(startBirdSwarm), [_pos, _count, _radius]] call CBA_fnc_serverEvent;
    [LLSTRING(BirdSwarmStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _pos, QGVAR(birdSwarmDialog)] call zen_dialog_fnc_create;
