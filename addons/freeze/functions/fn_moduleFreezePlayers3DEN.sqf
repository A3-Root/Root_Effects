#include "..\script_component.hpp"

/*
 * Author: Root
 * 3DEN module entry point for freezing players. Applies the configured
 * freeze state to every unit synchronized to the module when the mission
 * begins.
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
 * [_logic, [_unit], true] call root_effects_freeze_fnc_moduleFreezePlayers3DEN
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (is3DEN) exitWith {};
if (isNull _logic) exitWith {};

private _freeze = _logic getVariable ["ROOT_FREEZE_FREEZE", true];
private _useAnim = _logic getVariable ["ROOT_FREEZE_USEANIM", false];
private _animation = _logic getVariable ["ROOT_FREEZE_ANIM", "HubSpectator_stand"];

deleteVehicle _logic;

private _targets = _units select {!isNull _x && {_x isKindOf "CAManBase"}};
if (_targets isEqualTo []) exitWith {};

[_targets, _freeze, _useAnim, _animation] call FUNC(freezeApply);
