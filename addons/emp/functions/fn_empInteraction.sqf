#include "..\script_component.hpp"

/*
 * Author: Root
 * Adds the shutdown interaction to the object the field sits on: a vanilla hold
 * action, an ACE interaction with progress bar, or both. ACE mode falls back to
 * the hold action without ACE. Removed when the field ends.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empInteraction
 */

params [["_entry", [], [[]]]];
_entry params ["_anchor", "_cfg", "", "", "_object"];

if (!hasInterface || {isNull _object}) exitWith {};

private _mode = _cfg get "interaction";
if (_mode == 0) exitWith {};

private _hasAce = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");
private _title = LLSTRING(ActionDisable);
private _icon = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa";
private _actionId = -1;
private _aceName = QGVAR(disableAction);

if (_mode in [1, 3] || {_mode == 2 && !_hasAce}) then {
    _actionId = [
        _object, _title, _icon, _icon,
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
    }] call ace_interact_menu_fnc_createAction;
    [_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

// Remove both once the field is gone.
[{
    params ["_anchor"];
    isNull _anchor
}, {
    params ["", "_object", "_actionId", "_aceName"];
    if (isNull _object) exitWith {};
    if (_actionId >= 0) then {[_object, _actionId] call BIS_fnc_holdActionRemove};
    if (!isNil "ace_interact_menu_fnc_removeActionFromObject") then {
        [_object, 0, ["ACE_MainActions", _aceName]] call ace_interact_menu_fnc_removeActionFromObject;
    };
}, [_anchor, _object, _actionId, _aceName]] call CBA_fnc_waitUntilAndExecute;
