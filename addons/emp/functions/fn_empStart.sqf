#include "..\script_component.hpp"

/*
 * Author: Root
 * Server handler for the start event. Takes the create form [target, settings]
 * or the positional form [pos, radius, duration, killEngines, fuelDrain, hud,
 * electronics, permanent], which becomes an instant field with no dome, marker
 * or shutdown interaction.
 *
 * Arguments:
 * 0: Object or position ATL <OBJECT, ARRAY>
 * 1: Settings <ARRAY of [key, value]>, or radius in meters <NUMBER>
 * 2-7: Positional form only, see above
 *
 * Return Value:
 * Field anchor <OBJECT>
 *
 * Example:
 * [[1000, 2000, 0], 300, 20, true, 0, true, true, false] call root_effects_emp_fnc_empStart
 */

DBG(FORMAT_1("empStart called with %1",_this));

if (!isServer) exitWith {objNull};

if ((_this param [1, []]) isEqualType []) exitWith {
    _this call FUNC(create)
};

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 300, [0]],
    ["_duration", 20, [0]],
    ["_killEngines", true, [false]],
    ["_fuelDrain", 0, [0]],
    ["_hud", true, [false]],
    ["_electronics", true, [false]],
    ["_permanent", false, [false]]
];

[_pos, [
    ["radius", _radius],
    ["linger", [_duration max 5, -1] select _permanent],
    ["shockSpeed", 0],
    ["implodeSpeed", 0],
    ["restoreDelay", 0],
    ["effectDelay", 0],
    ["vehicles", parseNumber _killEngines],
    ["aircraft", parseNumber _killEngines],
    ["uavs", parseNumber _killEngines],
    ["fuelDrain", _fuelDrain],
    ["hud", _hud],
    ["gear", [0, [1, 2] select _permanent] select _electronics],
    ["lamps", [0, [1, 2] select _permanent] select _electronics],
    ["ai", _electronics],
    ["radios", _electronics],
    ["dome", false],
    ["marker", 0],
    ["interaction", 0],
    ["grace", 0]
]] call FUNC(create)
