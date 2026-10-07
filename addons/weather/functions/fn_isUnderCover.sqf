#include "..\script_component.hpp"

/*
 * Author: Root
 * Checks whether a unit has a roof over its head: inside a building's bounds
 * or with solid geometry above it. Several upward rays are cast around the
 * head so a gap in the roof or an open doorway does not count as exposed,
 * while a lone branch or lamp post does not count as shelter.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Covered <BOOL>
 *
 * Example:
 * [player] call root_effects_weather_fnc_isUnderCover
 */

params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith {false};
if (!isNull objectParent _unit) exitWith {true};

// Inside the footprint and height of the nearest building.
private _building = nearestBuilding _unit;
private _inside = false;
if (!isNull _building && {(_building distance _unit) < 60}) then {
    private _local = _building worldToModel (ASLToAGL getPosASL _unit);
    (boundingBoxReal _building) params ["_min", "_max"];
    _inside = (_local select 0) > (_min select 0) && {(_local select 0) < (_max select 0)}
        && {(_local select 1) > (_min select 1)} && {(_local select 1) < (_max select 1)}
        && {(_local select 2) > (_min select 2)} && {(_local select 2) < (_max select 2)};
};
if (_inside && {
    private _eye = eyePos _unit;
    lineIntersectsSurfaces [_eye, _eye vectorAdd [0, 0, 30], _unit, objNull, true, 1, "GEOM", "VIEW"] isNotEqualTo []
}) exitWith {true};

private _eye = eyePos _unit;
private _hits = 0;
{
    private _from = _eye vectorAdd _x;
    if (lineIntersectsSurfaces [_from, _from vectorAdd [0, 0, 50], _unit, objNull, true, 1, "GEOM", "VIEW"] isNotEqualTo []) then {
        _hits = _hits + 1;
    };
} forEach [[0, 0, 0.2], [0.7, 0, 0.2], [-0.7, 0, 0.2], [0, 0.7, 0.2], [0, -0.7, 0.2]];

_hits >= 3
