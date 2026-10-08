#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the briefing table diorama. Reads the module
 * attributes placed in the editor and builds a miniature of the marker area
 * on the synchronized (or nearest) table when the mission begins.
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
 * [_logic, [_table], true] call root_effects_briefing_fnc_moduleBriefingTable3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

DBG(FORMAT_1("moduleBriefingTable3DEN called with %1",_this));

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","BriefingTable",mapGridPosition _logic,allVariables _logic));

private _marker = _logic getVariable ["ROOT_BTABLE_MARKER", ""];
private _resolution = _logic getVariable ["ROOT_BTABLE_RESOLUTION", 20];
private _scale = _logic getVariable ["ROOT_BTABLE_SCALE", 1];
private _useTerrain = _logic getVariable ["ROOT_BTABLE_TERRAIN", true];
private _heightOffset = _logic getVariable ["ROOT_BTABLE_HEIGHT", 0.4];

// Use a synchronized table, or the nearest static object to the module.
private _table = objNull;
private _synced = _units select {!isNull _x};
if (_synced isNotEqualTo []) then {
    _table = _synced select 0;
} else {
    private _nearby = (nearestObjects [getPosATL _logic, ["Static"], 10]) select {!(_x isKindOf "Logic")};
    if (_nearby isNotEqualTo []) then {
        _table = _nearby select 0;
    };
};

deleteVehicle _logic;

if (isNull _table) exitWith {
    DBG("briefing table start rejected, no table object found near the module");
};

[_table, _marker, _resolution, _scale, _useTerrain, _heightOffset] call FUNC(briefingTableStart);
