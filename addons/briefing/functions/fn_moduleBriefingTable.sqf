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
private _pos = getPosATL _logic;
private _dir = getDir _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};
DBG(FORMAT_3("moduleBriefingTable used by %1 at %2, on table %3",profileName,mapGridPosition _pos,typeOf _table));

if (!(["briefingtable"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

// Placed on the ground: offer a table to spawn there, like the Drone Feed screen.
private _tableClasses = ["Land_BriefingRoomDesk_01_F", "Land_TableBig_01_F", "Land_WoodenTable_large_F", "Land_CampingTable_F", "Land_TablePlastic_01_F"];
private _tableNames = ["Briefing Room Desk", "Large Table", "Large Wooden Table", "Camping Table", "Plastic Table"];
private _rows = [
    ["EDIT", [LLSTRING(AttrTableMarker), LLSTRING(AttrTableMarkerTooltip)], [""]],
    ["SLIDER", [LLSTRING(AttrTableResolution), LLSTRING(AttrTableResolutionTooltip)], [8, 40, 20, 0]],
    ["SLIDER", [LLSTRING(AttrTableScale), LLSTRING(AttrTableScaleTooltip)], [0.2, 3, 1, 1]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrTableTerrain), LLSTRING(AttrTableTerrainTooltip)], true],
    ["SLIDER", [LLSTRING(AttrTableHeight), LLSTRING(AttrTableHeightTooltip)], [-1, 2, 0.4, 2]]
];
if (isNull _table) then {
    _rows pushBack ["COMBO", [LLSTRING(AttrTableSpawn), LLSTRING(AttrTableSpawnTooltip)], [_tableClasses, _tableNames, 0]];
};

[LLSTRING(ModuleTable), _rows, {
    params ["_results", "_data"];
    _data params ["_table", "_pos", "_dir"];
    _results params ["_marker", "_resolution", "_scale", "_useTerrain", "_heightOffset", ["_spawnClass", ""]];

    if (_marker isEqualTo "" || {getMarkerColor _marker isEqualTo ""}) exitWith {
        [LLSTRING(NoMarker)] call zen_common_fnc_showMessage;
    };

    [QGVAR(startTable), [_table, _marker, _resolution, _scale, _useTerrain, _heightOffset, ["", _spawnClass] select (isNull _table), _pos, _dir]] call EFUNC(main,serverEventLogged);
    [LLSTRING(TableStarted)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_table, _pos, _dir], QGVAR(tableDialog)] call zen_dialog_fnc_create;
