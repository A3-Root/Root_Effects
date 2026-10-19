#include "..\script_component.hpp"

/*
 * Author: Root
 * Registers an EMP field on this machine (JIP safe) and starts what runs here:
 * the field loop for local units and vehicles everywhere, and countdown,
 * detonation, dome, lamps, fog and shutdown interaction on machines with a player.
 *
 * Arguments:
 * 0: Field anchor <OBJECT>
 * 1: Settings <ARRAY of [key, value]>
 * 2: Object the field sits on <OBJECT>
 * 3: Detonation time (CBA_missionTime) <NUMBER>
 * 4: Object carrying the shutdown interaction of a field on the ground <OBJECT> (optional)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, _pairs, terminal_1, 120] call root_effects_emp_fnc_empFieldLocal
 */

params [["_anchor", objNull, [objNull]], ["_pairs", [], [[]]], ["_object", objNull, [objNull]], ["_detTime", 0, [0]], ["_interact", objNull, [objNull]]];

DBG(FORMAT_1("empFieldLocal called with %1",_this));

if (isNull _anchor) exitWith {};
if (GVAR(fields) findIf {(_x select 0) isEqualTo _anchor} != -1) exitWith {};

// Settings published later by modify win over the start event copy.
private _version = _anchor getVariable [QGVAR(cfgVer), -1];
if (_version > 0) then {_pairs = _anchor getVariable [QGVAR(cfg), _pairs]};
private _entry = [_anchor, createHashMapFromArray _pairs, _version, _detTime, _object, _interact];
GVAR(fields) pushBack _entry;

if (GVAR(loopHandle) < 0) then {
    GVAR(loopHandle) = [FUNC(empLoop), 0.5] call CBA_fnc_addPerFrameHandler;
};

if (!hasInterface) exitWith {};

call FUNC(empApproachLocal);
[_entry] call FUNC(empCountdownLocal);
[_entry] call FUNC(empDomeLocal);
[_entry] call FUNC(empLampsLocal);
[_entry] call FUNC(empFogLocal);
[_entry] call FUNC(empInteraction);

// Detonation effects only for those who see it happen.
if (CBA_missionTime < _detTime + 2) then {
    [{
        params ["_entry"];
        isNull (_entry select 0) || {CBA_missionTime >= (_entry select 3)}
    }, {
        params ["_entry"];
        if (isNull (_entry select 0) || {(_entry select 0) getVariable [QGVAR(ending), false]}) exitWith {};
        [_entry] call FUNC(empDetonateLocal);
    }, [_entry]] call CBA_fnc_waitUntilAndExecute;
};
