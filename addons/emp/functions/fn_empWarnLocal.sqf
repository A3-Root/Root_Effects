#include "..\script_component.hpp"

/*
 * Author: Root
 * Warns the player entering a live EMP field: crackle and screen flicker
 * for the grace time. Once per entry.
 *
 * Arguments:
 * 0: Grace time in seconds <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [5] call root_effects_emp_fnc_empWarnLocal
 */

params [["_grace", 5, [0]]];

if (!hasInterface) exitWith {};
if (CBA_missionTime < (missionNamespace getVariable [QGVAR(warnUntil), -1])) exitWith {};
GVAR(warnUntil) = CBA_missionTime + (_grace max 1) + 1;

playSound3D ["a3\missions_f_epa\data\sounds\electricity_loop.wss", objNull, false, getPosASL player, 2, 1.4, 30, 0, true];

if (_grace <= 0) exitWith {};

private _grain = ["FilmGrain", 2011] call EFUNC(main,ppCreate);
_grain ppEffectEnable true;

[{
    params ["_args", "_handle"];
    _args params ["_grain", "_end"];
    if (CBA_missionTime >= _end) exitWith {
        ppEffectDestroy _grain;
        _handle call CBA_fnc_removePerFrameHandler;
    };
    _grain ppEffectAdjust [random 0.25, 1, 1.5, 0.3, 1, false];
    _grain ppEffectCommit 0.1;
}, 0.15, [_grain, CBA_missionTime + _grace]] call CBA_fnc_addPerFrameHandler;
