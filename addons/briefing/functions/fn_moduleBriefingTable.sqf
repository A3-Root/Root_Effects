#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing table script by the 77th JSOC community
 * Zeus module entry point for the briefing table diorama. Requires the
 * module to be attached to a table object; opens the configuration dialog on
 * the curator's machine and asks the server to build a miniature of the
 * marker area on that table once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_briefing_fnc_moduleBriefingTable
 */

params [["_logic", objNull, [objNull]]];

private _table = attachedTo _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["briefingtable"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

if (isNull _table) exitWith {
    [LLSTRING(PlaceOnTable)] call zen_common_fnc_showMessage;
};

[LLSTRING(ModuleTable), [
    ["EDIT", [LLSTRING(AttrTableMarker), LLSTRING(AttrTableMarkerTooltip)], [""]],
    ["SLIDER", [LLSTRING(AttrTableResolution), LLSTRING(AttrTableResolutionTooltip)], [8, 40, 20, 0]],
    ["SLIDER", [LLSTRING(AttrTableScale), LLSTRING(AttrTableScaleTooltip)], [0.2, 3, 1, 1]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrTableTerrain), LLSTRING(AttrTableTerrainTooltip)], true]
], {
    params ["_results", "_table"];
    _results params ["_marker", "_resolution", "_scale", "_useTerrain"];

    if (_marker isEqualTo "" || {getMarkerColor _marker isEqualTo ""}) exitWith {
        [LLSTRING(NoMarker)] call zen_common_fnc_showMessage;
    };

    [QGVAR(startTable), [_table, _marker, _resolution, _scale, _useTerrain]] call CBA_fnc_serverEvent;
    [LLSTRING(TableStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, _table, QGVAR(tableDialog)] call zen_dialog_fnc_create;
