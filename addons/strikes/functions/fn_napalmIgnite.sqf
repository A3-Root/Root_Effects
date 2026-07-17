#include "..\script_component.hpp"

/*
 * Author: Root
 * Lights the burning corridor of a napalm strike on the server: creates the
 * anchor, broadcasts the fire wall to all clients (JIP safe) and runs the
 * periodic burn damage to units caught inside it. The instance removes itself
 * once the fire has burned out.
 *
 * Arguments:
 * 0: Center position ATL of the fire line <ARRAY>
 * 1: Attack heading in degrees <NUMBER>
 * 2: Fire line length in meters <NUMBER>
 * 3: Burn duration in seconds <NUMBER>
 * 4: Apply burn damage <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 0, 150, 180, true] call root_effects_strikes_fnc_napalmIgnite
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_heading", 0, [0]],
    ["_length", 150, [0]],
    ["_duration", 180, [0]],
    ["_damage", true, [false]]
];

if (!isServer) exitWith {};

private _anchor = ["napalmstrike", QGVAR(napalmLocal), [_heading, _length], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

if (_damage) then {
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_heading", "_length"];

        if (isNull _anchor) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _exposed = ((getPosATL _anchor) nearEntities [["Man", "LandVehicle"], _length]) select {
            _x inArea [getPosATL _anchor, _length / 2 + 10, 18, _heading, true]
        };
        {
            if (!(_x isKindOf "VirtualMan_F") && {(getPosATL _x select 2) < 10}) then {
                [_x, 0.25, "Body", "burn", _anchor] call EFUNC(main,doDamage);
            };
        } forEach _exposed;
    }, 2, [_anchor, _heading, _length]] call CBA_fnc_addPerFrameHandler;
};

// The fire burns out after the configured duration.
[{
    params ["_anchor"];
    ["napalmstrike", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], _duration] call CBA_fnc_waitAndExecute;
