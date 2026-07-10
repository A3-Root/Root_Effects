#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Runs one UFO crossing on the server: a fast object dropping out of the sky,
 * zigzagging over the area and shooting back up. The body is a global object
 * so its movement replicates naturally; glow and clouds are added by the
 * clients through the broadcast event.
 *
 * Arguments:
 * 0: Appearance position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 500]] call root_effects_ufo_fnc_crossFlyby
 */

params [["_appearPos", [0, 0, 0], [[]], 3]];

if (!isServer) exitWith {};

private _ufo = createVehicle ["Land_Battery_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_ufo setPosATL [_appearPos select 0, _appearPos select 1, 3000];
_ufo setVelocity [0, 0, -300];

[QGVAR(crossLocal), [_ufo]] call CBA_fnc_globalEvent;

// Dive for eight seconds, then zigzag a few times and leave straight up.
[{
    params ["_ufo"];
    if (isNull _ufo) exitWith {};

    [_ufo, [QGVAR(flyby), 3000]] remoteExec ["say3D"];

    private _zigzagState = [_ufo, 2 + round random 10];
    [{
        params ["_args", "_handle"];
        _args params ["_ufo", "_remaining"];

        if (isNull _ufo) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        if (_remaining <= 0) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;

            _ufo setVelocity [0, 0, 500];
            _ufo setVariable [QGVAR(crossComplete), true, true];

            [{
                params ["_ufo"];
                deleteVehicle _ufo;
            }, [_ufo], 6] call CBA_fnc_waitAndExecute;
        };

        _ufo setVelocity [(200 + round random 200) * selectRandom [-1, 1], 200, 1];
        _args set [1, _remaining - 1];
    }, 2, _zigzagState] call CBA_fnc_addPerFrameHandler;
}, [_ufo], 8] call CBA_fnc_waitAndExecute;
