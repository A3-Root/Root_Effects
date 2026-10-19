#include "..\script_component.hpp"

/*
 * Author: Root
 * Adds the shutdown interaction to the object the field sits on, or to the
 * invisible wall of a field on the ground: a vanilla hold action, an ACE
 * interaction with progress bar, or both. ACE mode falls back to the hold action
 * without ACE. Objects without ACE main actions get their own ACE action.
 * Removed when the field ends.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empInteraction
 */

params [["_entry", [], [[]]]];
_entry params ["_anchor", "_cfg", "", "", "_object", ["_interact", objNull]];

if (!hasInterface || {isNull _anchor}) exitWith {};

private _mode = _cfg get "interaction";
if (_mode == 0) exitWith {};

private _target = [_interact, _object] select (!isNull _object);

// The wall of a ground field may arrive after the start event: wait for it.
if (isNull _target) exitWith {
    if (!isNull _object) exitWith {};
    [{
        params ["_entry"];
        private _anchor = _entry select 0;
        isNull _anchor || {!isNull (_anchor getVariable [QGVAR(interact), objNull])}
    }, {
        params ["_entry"];
        private _anchor = _entry select 0;
        if (isNull _anchor) exitWith {};
        _entry set [5, _anchor getVariable [QGVAR(interact), objNull]];
        [_entry] call FUNC(empInteraction);
    }, [_entry], 30] call CBA_fnc_waitUntilAndExecute;
};

private _hasAce = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");
private _title = LLSTRING(ActionDisable);
private _icon = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa";
private _actionId = -1;
private _aceName = QGVAR(disableAction);
private _acePath = [];

if (_mode in [1, 3] || {_mode == 2 && !_hasAce}) then {
    _actionId = [
        _target, _title, _icon, _icon,
        format ["[_target, _this] call %1", QFUNC(empCanDisable)],
        format ["[_target, _caller] call %1", QFUNC(empCanDisable)],
        {}, {},
        {
            params ["_target"];
            [_target] call FUNC(disable);
        },
        {},
        [], (_cfg get "holdTime") max 0.5, 1000, true, false
    ] call BIS_fnc_holdActionAdd;
};

if (_mode in [2, 3] && _hasAce) then {
    // Objects without ACE main actions take the action at their root.
    private _hasMain = isClass (configOf _target >> "ACE_Actions" >> "ACE_MainActions");
    _acePath = [[], ["ACE_MainActions"]] select _hasMain;
    private _distance = (((boundingBoxReal _target) select 2) max 2) min 10;
    private _action = [_aceName, _title, _icon, {
        params ["_target", "_player"];
        private _cfg = createHashMapFromArray ((_target getVariable [QGVAR(anchor), objNull]) getVariable [QGVAR(cfg), []]);
        [
            _cfg getOrDefault ["holdTime", 10],
            [_target, _player],
            {
                (_this select 0) params ["_target"];
                [_target] call FUNC(disable);
            },
            {},
            LLSTRING(ActionDisable),
            {
                (_this select 0) params ["_target", "_player"];
                [_target, _player] call FUNC(empCanDisable)
            }
        ] call ace_common_fnc_progressBar;
    }, {
        params ["_target", "_player"];
        [_target, _player] call FUNC(empCanDisable)
    }, {}, [], [0, 0, 0], _distance] call ace_interact_menu_fnc_createAction;
    [_target, 0, _acePath, _action] call ace_interact_menu_fnc_addActionToObject;
};

DBG(FORMAT_4("EMP shutdown interaction on %1, mode %2, hold action %3, ACE path %4",typeOf _target,_mode,_actionId,_acePath));

// Remove both once the field is gone.
[{
    params ["_anchor"];
    isNull _anchor
}, {
    params ["", "_target", "_actionId", "_aceName", "_acePath"];
    if (isNull _target) exitWith {};
    if (_actionId >= 0) then {[_target, _actionId] call BIS_fnc_holdActionRemove};
    if (!isNil "ace_interact_menu_fnc_removeActionFromObject") then {
        [_target, 0, _acePath + [_aceName]] call ace_interact_menu_fnc_removeActionFromObject;
    };
}, [_anchor, _target, _actionId, _aceName, _acePath]] call CBA_fnc_waitUntilAndExecute;
