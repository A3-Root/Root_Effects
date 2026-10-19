#include "..\script_component.hpp"

/*
 * Author: Root
 * Keeps the ACRE signal hook in place while a field jams radios: zero signal
 * when the receiving or the transmitting radio is inside a field the shockwave
 * reached. Wraps whatever custom signal function was set before (and one set
 * later), and puts it back once no field jams.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call root_effects_emp_fnc_empAcreSignal
 */

if (isNil "acre_api_fnc_setCustomSignalFunc") exitWith {};

private _active = GVAR(acreJam) && {GVAR(fields) findIf {(_x select 1) get "radios"} != -1};
private _current = missionNamespace getVariable ["acre_sys_signal_customSignalFunc", {}];

if (isNil QGVAR(acreFunc)) then {
    GVAR(acreFunc) = {
        params ["", "", "_rxRadio", "_txRadio"];
        private _signal = if (isNil QGVAR(acrePrev)) then {
            _this call acre_sys_signal_fnc_getSignalCore
        } else {
            _this call GVAR(acrePrev)
        };
        private _fnc_jammed = {
            params ["_radio"];
            private _pos = [_radio] call acre_sys_radio_fnc_getRadioPos;
            !isNil "_pos" && {_pos isEqualType []} && {
                GVAR(fields) findIf {((_x select 1) get "radios") && {[_pos, _x] call FUNC(empInZone)}} != -1
            }
        };
        if ([_rxRadio] call _fnc_jammed || {[_txRadio] call _fnc_jammed}) then {
            _signal = [0, -992];
        };
        _signal
    };
};

if (_active) then {
    if (_current isNotEqualTo GVAR(acreFunc)) then {
        GVAR(acrePrev) = if (_current isEqualTo {}) then {nil} else {_current};
        [GVAR(acreFunc)] call acre_api_fnc_setCustomSignalFunc;
        DBG("EMP ACRE signal hook installed");
    };
} else {
    if (_current isEqualTo GVAR(acreFunc)) then {
        [missionNamespace getVariable [QGVAR(acrePrev), {}]] call acre_api_fnc_setCustomSignalFunc;
        GVAR(acrePrev) = nil;
        DBG("EMP ACRE signal hook removed");
    };
};
