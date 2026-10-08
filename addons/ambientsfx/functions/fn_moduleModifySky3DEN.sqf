#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module: when activated (by its trigger, or at mission start without one)
 * changes the aurora or spacetime rupture closest to it. Waits briefly for the
 * sky effect to exist so it can sit next to a sky module that starts at the
 * same time.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call root_effects_ambientsfx_fnc_moduleModifySky3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

DBG(FORMAT_1("moduleModifySky3DEN called with %1",_this));

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

DBG(FORMAT_3("3DEN module fired: %1 at %2, attributes %3","ModifySky",mapGridPosition _logic,allVariables _logic));

private _pos = getPosATL _logic;
private _range = _logic getVariable ["ROOT_SKYMOD_RANGE", 3000];
private _settings = [
    _logic getVariable ["ROOT_SKYMOD_FREEZE", false],
    _logic getVariable ["ROOT_SKYMOD_SPAWN", true],
    _logic getVariable ["ROOT_SKYMOD_DESPAWN", true],
    _logic getVariable ["ROOT_SKYMOD_SIZE", 1],
    _logic getVariable ["ROOT_SKYMOD_LENGTH", 1],
    _logic getVariable ["ROOT_SKYMOD_SHAPE", 6],
    _logic getVariable ["ROOT_SKYMOD_SWITCH", 0],
    _logic getVariable ["ROOT_SKYMOD_MOVESPEED", 0],
    _logic getVariable ["ROOT_SKYMOD_MOVEMODE", 0]
];
deleteVehicle _logic;

private _fnc_find = {
    params ["_pos", "_range"];
    (nearestObjects [[_pos select 0, _pos select 1, 0], [ANCHOR_CLASS], _range max 100]) select {
        (_x getVariable [QEGVAR(main,effectKey), ""]) in ["aurora", "rupture"]
    }
};

[{
    params ["_pos", "_range", "_settings", "_fnc_find"];
    ([_pos, _range] call _fnc_find) isNotEqualTo []
}, {
    params ["_pos", "_range", "_settings", "_fnc_find"];
    private _anchor = ([_pos, _range] call _fnc_find) select 0;
    DBG(FORMAT_2("sky modify 3DEN module applying to effect at %1: %2",mapGridPosition _anchor,_settings));
    ([_anchor] + _settings) call FUNC(skyModify);
}, [_pos, _range, _settings, _fnc_find], 15, {
    params ["_pos", "_range"];
    DBG(FORMAT_2("sky modify 3DEN module found no aurora or rupture within %1 m of %2",_range,mapGridPosition _pos));
}] call CBA_fnc_waitUntilAndExecute;
