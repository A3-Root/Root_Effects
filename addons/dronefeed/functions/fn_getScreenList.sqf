#include "..\script_component.hpp"

/*
 * Author: Root
 * Builds a picker list of nearby world objects that can display a feed texture
 * (screens, boards and other static props), each paired with a readable label.
 *
 * Arguments:
 * 0: Center position ATL <ARRAY>
 * 1: Search radius in meters <NUMBER> (default: 50)
 *
 * Return Value:
 * [[object, label], ...] <ARRAY>
 *
 * Example:
 * [getPosATL _logic, 50] call root_effects_dronefeed_fnc_getScreenList
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 50, [0]]];

private _result = [];
{
    // Skip units, crewed vehicles and the invisible effect anchors.
    if (
        !(_x isKindOf "Man") &&
        {!(_x isKindOf "AllVehicles")} &&
        {(typeOf _x) isNotEqualTo ANCHOR_CLASS} &&
        {getArray (configOf _x >> "hiddenSelectionsTextures") isNotEqualTo [] || {_x isKindOf "Land_TripodScreen_01_large_F"}}
    ) then {
        private _label = format ["%1 (%2m)", getText (configOf _x >> "displayName"), round (_pos distance2D _x)];
        _result pushBack [_x, _label];
    };
} forEach (nearestObjects [_pos, [], _radius]);

_result
