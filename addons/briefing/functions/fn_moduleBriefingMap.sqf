#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing map script by the 77th JSOC community
 * Zeus module entry point for the live briefing map. Opens the configuration
 * dialog on the curator's machine and asks the server to place a map board
 * with a live map feed at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_briefing_fnc_moduleBriefingMap
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
private _dir = getDir _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["briefingmap"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleMap), [
    ["EDIT", [LLSTRING(AttrMapMarker), LLSTRING(AttrMapMarkerTooltip)], [""]],
    ["SLIDER", [LLSTRING(AttrMapZoom), LLSTRING(AttrMapZoomTooltip)], [0.02, 1, 0.1, 2]],
    ["SLIDER:RADIUS", [LLSTRING(AttrMapActDist), LLSTRING(AttrMapActDistTooltip)], [10, 500, 50, 0, _pos, [7, 120, 32, 1]]]
], {
    params ["_results", "_data"];
    _data params ["_pos", "_dir"];
    _results params ["_centerMarker", "_zoom", "_activationDistance"];

    [QGVAR(startMap), [_pos, _dir, _centerMarker, _zoom, _activationDistance]] call CBA_fnc_serverEvent;
    [LLSTRING(MapStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_pos, _dir], QGVAR(mapDialog)] call zen_dialog_fnc_create;
