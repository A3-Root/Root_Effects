#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for the meteors and comets effect. Reads the
 * module attributes placed in the editor and starts the selected spawners
 * when the mission begins.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Module activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call root_effects_meteor_fnc_moduleMeteorsComets3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _pos = getPosATL _logic;
private _meteors = _logic getVariable ["ROOT_METEOR_METEORS", false];
private _meteorFreq = _logic getVariable ["ROOT_METEOR_METEORFREQ", 30];
private _comets = _logic getVariable ["ROOT_METEOR_COMETS", false];
private _cometFreq = _logic getVariable ["ROOT_METEOR_COMETFREQ", 30];
private _lethal = _logic getVariable ["ROOT_METEOR_LETHAL", true];

// Only the player and area modes are offered here; picking out specific sides,
// groups or players needs the curator interface.
private _targetMode = (_logic getVariable ["ROOT_METEOR_TARGETMODE", 0]) min 1;
private _targetRadius = _logic getVariable ["ROOT_METEOR_TARGETRADIUS", 300];

deleteVehicle _logic;

if (_meteors) then {
    [_pos, _meteorFreq, _lethal, _targetMode, _targetRadius, []] call FUNC(meteorsStart);
};
if (_comets) then {
    [_pos, _cometFreq, _targetMode, _targetRadius, []] call FUNC(cometsStart);
};
