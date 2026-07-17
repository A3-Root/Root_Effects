#include "..\script_component.hpp"

/*
 * Author: Root
 * Kills street and building lamps inside the pulse radius on this machine.
 * Lamps are terrain objects that exist on every machine and switchLight only
 * affects the local copy, so this runs everywhere rather than being routed to
 * an owner. Unless the blackout is permanent the lamps come back on once the
 * interference passes.
 *
 * Arguments:
 * 0: Pulse center position ATL <ARRAY>
 * 1: Pulse radius in meters <NUMBER>
 * 2: Interference duration in seconds <NUMBER>
 * 3: Lamps stay dead <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 300, 20, false] call root_effects_emp_fnc_empLampsLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 300, [0]], ["_duration", 20, [0]], ["_permanent", false, [false]]];

private _lamps = nearestObjects [_pos, ["Lamps_base_F", "PowerLines_base_F"], _radius];
if (_lamps isEqualTo []) exitWith {};

{
    _x switchLight "OFF";
} forEach _lamps;

if (_permanent) exitWith {};

[{
    params ["_lamps"];
    {
        if (!isNull _x) then {
            _x switchLight "ON";
        };
    } forEach _lamps;
}, [_lamps], _duration] call CBA_fnc_waitAndExecute;
