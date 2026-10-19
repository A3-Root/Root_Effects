#include "..\script_component.hpp"

/*
 * Author: Root
 * Public API. Changes settings of a running EMP field live. Countdown changes
 * are ignored once the field is created. Called on a client, the request is
 * sent to the server.
 *
 * Arguments:
 * 0: Field anchor, or the object the field sits on <OBJECT>
 * 1: Settings to change <HASHMAP, ARRAY of [key, value]>
 *
 * Return Value:
 * None
 *
 * Example:
 * [terminal_1, createHashMapFromArray [["radius", 600], ["dome", false]]] call root_effects_emp_fnc_modify
 */

params [["_target", objNull, [objNull]], ["_settings", [], [[], createHashMap]]];

DBG(FORMAT_1("modify called with %1",_this));

if (_settings isEqualType createHashMap) then {
    _settings = keys _settings apply {[_x, _settings get _x]};
};

if (!isServer) exitWith {
    [QGVAR(modify), [_target, _settings]] call CBA_fnc_serverEvent;
};

private _anchor = _target;
if ((_target getVariable [QEGVAR(main,effectKey), ""]) isNotEqualTo "emp") then {
    _anchor = _target getVariable [QGVAR(anchor), objNull];
};
if (isNull _anchor) exitWith {};

private _cfg = +(_anchor getVariable [QGVAR(cfgMap), call FUNC(empDefaults)]);
private _countdown = _cfg get "countdown";
_cfg merge [createHashMapFromArray _settings, true];
_cfg set ["countdown", _countdown];
_cfg = [_cfg] call FUNC(empClamp);

_anchor setVariable [QGVAR(cfgMap), _cfg];
_anchor setVariable [QGVAR(cfg), keys _cfg apply {[_x, _cfg get _x]}, true];
_anchor setVariable [QGVAR(cfgVer), (_anchor getVariable [QGVAR(cfgVer), 0]) + 1, true];

DBG(FORMAT_2("EMP field at %1 modified: %2",mapGridPosition _anchor,_settings));
