#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs a napalm strike on the server: sends a plane over the target line,
 * then ignites a burning corridor along it. The fire wall is rendered
 * locally by every client; the server only runs the periodic burn damage to
 * units inside the corridor and removes the instance once the fire dies.
 *
 * Arguments:
 * 0: Center position ATL of the fire line <ARRAY>
 * 1: Aircraft class for the flyby <STRING>
 * 2: Attack heading in degrees <NUMBER>
 * 3: Fire line length in meters <NUMBER>
 * 4: Burn duration in seconds <NUMBER>
 * 5: Apply burn damage <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], "B_Plane_CAS_01_dynamicLoadout_F", 0, 150, 90, true] call root_effects_strikes_fnc_napalmStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_planeClass", "B_Plane_CAS_01_dynamicLoadout_F", [""]],
    ["_heading", 0, [0]],
    ["_length", 150, [0]],
    ["_duration", 90, [0]],
    ["_damage", true, [false]]
];

if (!isServer) exitWith {};
if (!(["napalmstrike"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (!isClass (configFile >> "CfgVehicles" >> _planeClass)) exitWith {
    DBG(FORMAT_1("napalm start rejected, unknown plane class %1",_planeClass));
};

_length = _length max 50;
_duration = _duration max 15;
_damage = _damage && GVAR(allowDamage);

// Attack run announcing the drop.
[_planeClass, ATLToASL _pos, true, 300, 4000, floor (_heading / 45), 2, 1] call zen_modules_fnc_moduleAmbientFlyby;

[{
    params ["_pos", "_heading", "_length", "_duration", "_damage"];

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
}, [_pos, _heading, _length, _duration, _damage], 12] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("napalm strike inbound, length %1, duration %2",_length,_duration));
