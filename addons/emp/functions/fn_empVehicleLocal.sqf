#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies the EMP electrical failure to a vehicle on the machine where it is
 * local: cuts the engine and keeps it dead for the interference duration,
 * optionally draining part of the fuel.
 *
 * Arguments:
 * 0: Affected vehicle <OBJECT>
 * 1: Interference duration in seconds <NUMBER>
 * 2: Cut and block the engine <BOOL>
 * 3: Fraction of fuel drained, 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, 20, true, 0] call root_effects_emp_fnc_empVehicleLocal
 */

params [["_vehicle", objNull, [objNull]], ["_duration", 20, [0]], ["_killEngines", true, [false]], ["_fuelDrain", 0, [0]]];

if (isNull _vehicle || {!local _vehicle}) exitWith {};

if (_fuelDrain > 0) then {
    _vehicle setFuel ((fuel _vehicle) * (1 - _fuelDrain) max 0);
};

if (_killEngines) then {
    _vehicle engineOn false;
    _vehicle setVariable [QGVAR(disabledUntil), CBA_missionTime + _duration];

    // Keep the engine dead until the interference fades.
    [{
        params ["_args", "_handle"];
        _args params ["_vehicle"];

        if (isNull _vehicle || {!local _vehicle} || {CBA_missionTime >= (_vehicle getVariable [QGVAR(disabledUntil), 0])}) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        if (isEngineOn _vehicle) then {
            _vehicle engineOn false;
        };
    }, 1, [_vehicle]] call CBA_fnc_addPerFrameHandler;
};
