#include "..\script_component.hpp"

/*
 * Author: Root
 * Public API. Creates an EMP field on an object or at a position. Called on a
 * client, the request is sent to the server. Missing settings take the values
 * from empDefaults.
 *
 * Arguments:
 * 0: Object to anchor the field to, or position ATL <OBJECT, ARRAY>
 * 1: Settings <HASHMAP, ARRAY of [key, value]> (optional)
 *
 * Return Value:
 * Field anchor on the server, objNull elsewhere <OBJECT>
 *
 * Example:
 * [terminal_1, createHashMapFromArray [["radius", 400], ["countdown", 30]]] call root_effects_emp_fnc_create
 */

params [["_target", objNull, [objNull, []]], ["_settings", [], [[], createHashMap]]];

DBG(FORMAT_1("create called with %1",_this));

if (_settings isEqualType createHashMap) then {
    _settings = keys _settings apply {[_x, _settings get _x]};
};

if (!isServer) exitWith {
    [QGVAR(create), [_target, _settings]] call CBA_fnc_serverEvent;
    objNull
};
if (!(["emp"] call EFUNC(main,isEffectEnabled))) exitWith {objNull};

private _object = objNull;
private _pos = [];
if (_target isEqualType objNull) then {
    _object = _target;
    _pos = getPosATL _target;
} else {
    _pos = +_target;
};
if (_pos isEqualTo [] || {_pos isEqualTo [0, 0, 0] && isNull _object}) exitWith {objNull};

private _cfg = call FUNC(empDefaults);
_cfg merge [createHashMapFromArray _settings, true];
_cfg = [_cfg] call FUNC(empClamp);

private _detTime = CBA_missionTime + (_cfg get "countdown");
private _pairs = keys _cfg apply {[_x, _cfg get _x]};

private _anchor = ["emp", QGVAR(fieldLocal), [_pairs, _object, _detTime], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {objNull};

if (!isNull _object) then {
    _anchor attachTo [_object, [0, 0, 0]];
    _object setVariable [QGVAR(anchor), _anchor, true];
};
_anchor setVariable [QGVAR(cfgMap), _cfg];
_anchor setVariable [QGVAR(cfg), _pairs, true];
_anchor setVariable [QGVAR(cfgVer), 0, true];
_anchor setVariable [QGVAR(detTime), _detTime, true];
_anchor setVariable [QGVAR(object), _object, true];
_anchor setVariable [QGVAR(ending), false, true];

[_anchor] call FUNC(empServer);

DBG(FORMAT_4("EMP field created at %1 on %2, radius %3, countdown %4",mapGridPosition _pos,typeOf _object,_cfg get "radius",_cfg get "countdown"));

_anchor
