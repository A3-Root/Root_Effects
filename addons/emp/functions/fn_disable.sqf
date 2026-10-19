#include "..\script_component.hpp"

/*
 * Author: Root
 * Public API. Shuts an EMP field down: the dome fades, the marker goes and every
 * suppressed or disabled item recovers. Destroyed or fried items stay broken.
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

// Time for the dome to fade before the anchor goes.
[{
    params ["_anchor"];
    if (isNull _anchor) exitWith {};
    ["emp", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], 2] call CBA_fnc_waitAndExecute;
