#include "..\script_component.hpp"

/*
 * Author: Root
 * Public API. Shuts an EMP field down: the dome fades or implodes (endMode), the
 * marker goes and every suppressed or disabled item recovers. Destroyed or fried
 * items stay broken. Implosion with implodeBlast sets off a grenade (1) or mortar
 * shell (2) at the center when the dome has collapsed.
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

_anchor setVariable [QGVAR(ending), true, true];
DBG(FORMAT_1("EMP field at %1 shutting down",mapGridPosition _anchor));

private _cfg = _anchor getVariable [QGVAR(cfgMap), createHashMap];
private _implode = (_cfg getOrDefault ["endMode", 0]) == 1;
private _blast = _cfg getOrDefault ["implodeBlast", 0];

if (_implode && _blast > 0) then {
    [{
        params ["_anchor", "_blast"];
        if (isNull _anchor) exitWith {};
        private _ammo = createVehicle [["G_40mm_HE", "Sh_82mm_AMOS"] select (_blast - 1), (getPosATL _anchor) vectorAdd [0, 0, 0.5], [], 0, "CAN_COLLIDE"];
        triggerAmmo _ammo;
        DBG(FORMAT_2("EMP implosion blast %1 at %2",_blast,mapGridPosition _anchor));
    }, [_anchor, _blast], IMPLODE_TIME] call CBA_fnc_waitAndExecute;
};

// Time for the dome to fade or collapse before the anchor goes.
[{
    params ["_anchor"];
    if (isNull _anchor) exitWith {};
    ["emp", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], [2, IMPLODE_TIME + 0.5] select _implode] call CBA_fnc_waitAndExecute;
