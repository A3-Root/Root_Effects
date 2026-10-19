#include "..\script_component.hpp"

/*
 * Author: Root
 * Clamps EMP settings to valid ranges and applies the server CBA caps.
 *
 * Arguments:
 * 0: Settings <HASHMAP>
 *
 * Return Value:
 * Settings <HASHMAP>
 *
 * Example:
 * [_cfg] call root_effects_emp_fnc_empClamp
 */

params [["_cfg", createHashMap, [createHashMap]]];

private _fnc_num = {
    params ["_key", "_min", "_max"];
    private _value = _cfg getOrDefault [_key, _min];
    if !(_value isEqualType 0) then {_value = _min};
    _cfg set [_key, (_value max _min) min _max];
};

["radius", 10, 5000] call _fnc_num;
["countdown", 0, 3600] call _fnc_num;
["shockSpeed", 0, 2000] call _fnc_num;
["effectDelay", 0, 120] call _fnc_num;
["grace", 0, 120] call _fnc_num;
["warnGround", 0, 2000] call _fnc_num;
["warnHeli", 0, 5000] call _fnc_num;
["warnPlane", 0, 10000] call _fnc_num;
["holdTime", 0, 300] call _fnc_num;
["fuelDrain", 0, 1] call _fnc_num;
["domeAlpha", 0.01, 1] call _fnc_num;
{
    [_x, 0, 2] call _fnc_num;
    _cfg set [_x, round (_cfg get _x)];
} forEach ["vehicles", "aircraft", "uavs", "lamps", "gear", "marker"];
["interaction", 0, 3] call _fnc_num;
_cfg set ["interaction", round (_cfg get "interaction")];

// -1 keeps its meaning: no height limit / until disabled.
private _altitude = _cfg getOrDefault ["altitude", -1];
_cfg set ["altitude", [(_altitude max 5) min 5000, -1] select (_altitude < 0)];
private _linger = _cfg getOrDefault ["linger", 60];
_cfg set ["linger", [(_linger max 1) min 86400, -1] select (_linger < 0)];

private _color = _cfg getOrDefault ["domeColor", [0.5, 0.5, 0.5]];
if (_color isEqualType "") then {
    _color = (_color splitString ",") apply {parseNumber _x};
};
if (count _color < 3) then {_color = [0.5, 0.5, 0.5]};
_cfg set ["domeColor", (_color select [0, 3]) apply {(_x max 0) min 1}];

if (!GVAR(allowVehicleKill)) then {
    _cfg set ["vehicles", 0];
    _cfg set ["aircraft", 0];
};
if (!GVAR(allowDestroy) || {!EGVAR(main,damageAllowed)}) then {
    {
        _cfg set [_x, (_cfg get _x) min 1];
    } forEach ["vehicles", "aircraft", "uavs"];
};
if (!GVAR(allowDestroy)) then {
    _cfg set ["gear", (_cfg get "gear") min 1];
};

_cfg
