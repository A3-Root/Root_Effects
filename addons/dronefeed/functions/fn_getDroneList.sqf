#include "..\script_component.hpp"

/*
 * Author: Root
 * Builds a picker list of the airborne UAVs currently in the mission, each
 * entry paired with a readable label, for the feed configuration dialogs.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * [[drone, label], ...] <ARRAY>
 *
 * Example:
 * call root_effects_dronefeed_fnc_getDroneList
 */

private _result = [];
{
    if (alive _x && {unitIsUAV _x} && {_x isKindOf "Air"}) then {
        private _label = format ["%1 (%2)", getText (configOf _x >> "displayName"), mapGridPosition _x];
        _result pushBack [_x, _label];
    };
} forEach vehicles;

_result
