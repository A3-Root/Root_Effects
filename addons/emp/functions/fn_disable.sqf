#include "..\script_component.hpp"

/*
 * Author: Root
 * Public API. Shuts an EMP field down. Fade (endMode 0): the dome fades, the marker
 * goes and every suppressed or disabled item recovers. Implode (endMode 1): the
 * wall runs back in at shockSpeed (shockSpeed 0: in IMPLODE_TIME s), the marker
 * shrinks with it and items recover as it passes. implodeBlast sets off a grenade
 * (1) or mortar shell (2) at the center when the dome has collapsed. Destroyed or
 * fried items stay broken.
 * Called on a client, the request is sent to the server.
 *
 * Arguments:
 * 0: Field anchor, or the object the field sits on <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [terminal_1] call root_effects_emp_fnc_disable
 */

params [["_target", objNull, [objNull]]];

DBG(FORMAT_1("disable called with %1",_this));

if (!isServer) exitWith {
    [QGVAR(disable), [_target]] call CBA_fnc_serverEvent;
};

private _anchor = _target;
if ((_target getVariable [QEGVAR(main,effectKey), ""]) isNotEqualTo "emp") then {
    _anchor = _target getVariable [QGVAR(anchor), objNull];
};
if (isNull _anchor) exitWith {};
if (_anchor getVariable [QGVAR(ending), false]) exitWith {};

private _cfg = _anchor getVariable [QGVAR(cfgMap), createHashMap];
private _implode = (_cfg getOrDefault ["endMode", 0]) == 1;
private _blast = _cfg getOrDefault ["implodeBlast", 0];
private _radius = _cfg getOrDefault ["radius", 300];
private _speed = _cfg getOrDefault ["shockSpeed", 0];
if (_speed <= 0) then {_speed = _radius / IMPLODE_TIME};
private _collapse = [2, _radius / _speed] select _implode;

_anchor setVariable [QGVAR(endTime), CBA_missionTime, true];
_anchor setVariable [QGVAR(endSpeed), _speed, true];
_anchor setVariable [QGVAR(ending), true, true];
DBG(FORMAT_2("EMP field at %1 shutting down in %2 s",mapGridPosition _anchor,_collapse));

if (_implode && _blast > 0) then {
    [{
        params ["_anchor", "_blast"];
        if (isNull _anchor) exitWith {};
        private _ammo = createVehicle [["G_40mm_HE", "Sh_82mm_AMOS"] select (_blast - 1), (getPosATL _anchor) vectorAdd [0, 0, 0.5], [], 0, "CAN_COLLIDE"];
        // Fuse distance 0, so the fresh shell does not dud.
        triggerAmmo [_ammo, -1, 0];
        DBG(FORMAT_2("EMP implosion blast %1 at %2",_blast,mapGridPosition _anchor));
    }, [_anchor, _blast], _collapse] call CBA_fnc_waitAndExecute;
};

// Time for the dome to fade or run in before the anchor goes.
[{
    params ["_anchor"];
    if (isNull _anchor) exitWith {};
    ["emp", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], _collapse + 0.5] call CBA_fnc_waitAndExecute;
