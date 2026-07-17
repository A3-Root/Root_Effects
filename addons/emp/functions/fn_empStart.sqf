#include "..\script_component.hpp"

/*
 * Author: Root
 * Detonates an EMP pulse on the server: broadcasts the sensory pulse to all
 * clients and forwards the electrical failure to the machine of every
 * vehicle inside the radius, where engines cut out and optionally fuel
 * drains. One shot per call.
 *
 * Arguments:
 * 0: Pulse center position ATL <ARRAY>
 * 1: Pulse radius in meters <NUMBER>
 * 2: Interference duration in seconds <NUMBER>
 * 3: Cut vehicle engines <BOOL>
 * 4: Fraction of fuel drained from vehicles, 0..1 <NUMBER>
 * 5: Distort the HUD of players inside the radius <BOOL>
 * 6: Knock out lamps and carried electronics <BOOL>
 * 7: Electronics stay dead instead of recovering after the duration <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 300, 20, true, 0, true, true, false] call root_effects_emp_fnc_empStart
 */

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

if (!isServer) exitWith {};
if (!(["emp"] call EFUNC(main,isEffectEnabled))) exitWith {};

_duration = _duration max 5;
_killEngines = _killEngines && GVAR(allowVehicleKill);

[QGVAR(pulseLocal), [_pos, _radius, _duration, _hud]] call CBA_fnc_globalEvent;

if (_killEngines || {_fuelDrain > 0}) then {
    {
        private _vehicle = _x;
        if (!(_vehicle isKindOf "Man") && {alive _vehicle}) then {
            [QGVAR(vehicleLocal), [_vehicle, _duration, _killEngines, _fuelDrain], [_vehicle]] call CBA_fnc_targetEvent;
        };
    } forEach (_pos nearEntities [["LandVehicle", "Air", "Ship"], _radius]);
};

if (_electronics) then {
    // Terrain lamps exist on every machine and switchLight is a local effect,
    // so each machine darkens its own copies.
    [QGVAR(lampsLocal), [_pos, _radius, _duration, _permanent]] call CBA_fnc_globalEvent;

    // Worn and carried gear can only be touched where the unit is local.
    {
        private _unit = _x;
        if (alive _unit && {!(_unit isKindOf "VirtualMan_F")}) then {
            [QGVAR(unitLocal), [_unit, _duration, _permanent], [_unit]] call CBA_fnc_targetEvent;
        };
    } forEach (_pos nearEntities [["CAManBase"], _radius]);
};

DBG(FORMAT_2("emp pulse fired, radius %1, duration %2",_radius,_duration));
