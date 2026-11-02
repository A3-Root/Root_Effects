#include "..\script_component.hpp"

/*
 * Author: Root
 * Keeps the ACRE signal hook in place while a field jams radios. Zero signal per
 * field radios mode: 1, one radio inside the field and the other outside;
 * 2, either radio inside the field or carried by a player not yet recovered
 * (radioJam). Wraps whatever custom signal function was set before (and one set
 * later), and puts it back once no field jams. Mode 2 also disables ACRE
 * transmitting (acre_sys_core_isDisabledRadio) for the local player while
 * jammed or inside the field.
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

private _active = GVAR(acreJam) && {GVAR(fields) findIf {((_x select 1) get "radios") > 0} != -1};
private _current = missionNamespace getVariable ["acre_sys_signal_customSignalFunc", {}];

if (isNil QGVAR(acreFunc)) then {
    GVAR(acreFunc) = {
        params ["", "", "_rxRadio", "_txRadio"];
        private _signal = if (isNil QGVAR(acrePrev)) then {
            _this call acre_sys_signal_fnc_getSignalCore
        } else {
            _this call GVAR(acrePrev)
        };
        // [radioJam holder, inside per field]
        private _fnc_state = {
            params ["_radio"];
            private _pos = [_radio] call acre_sys_radio_fnc_getRadioPos;
            private _holder = [_radio] call acre_sys_radio_fnc_getRadioObject;
            if (isNil "_pos" || {!(_pos isEqualType [])}) then {_pos = [0, 0, 0]};
            [
                !isNil "_holder" && {_holder isEqualType objNull} && {_holder getVariable [QGVAR(radioJam), false]},
                GVAR(fields) apply {((_x select 1) get "radios") > 0 && {[_pos, _x] call FUNC(empInZone)}}
            ]
        };
        ([_rxRadio] call _fnc_state) params ["_rxJam", "_rxIn"];
        ([_txRadio] call _fnc_state) params ["_txJam", "_txIn"];
        private _jammed = false;
        {
            private _mode = (_x select 1) get "radios";
            private _rx = _rxIn select _forEachIndex;
            private _tx = _txIn select _forEachIndex;
            if ((_mode == 1 && _rx isNotEqualTo _tx) || {_mode == 2 && {_rx || _tx || _rxJam || _txJam}}) exitWith {
                _jammed = true;
            };
        } forEach GVAR(fields);
        if (_jammed) then {
            _signal = [0, -999];
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

// Mode 2: block transmitting while the local player is jammed or inside the field.
private _unit = missionNamespace getVariable ["acre_player", player];
private _txBlock = _active && {
    private _pos = getPosASL _unit;
    private _jam = _unit getVariable [QGVAR(radioJam), false];
    GVAR(fields) findIf {((_x select 1) get "radios") == 2 && {_jam || {[_pos, _x] call FUNC(empInZone)}}} != -1
};
if (_txBlock) then {
    if !(_unit getVariable ["acre_sys_core_isDisabledRadio", false]) then {
        _unit setVariable ["acre_sys_core_isDisabledRadio", true, true];
        GVAR(acreTxBlock) = _unit;
    };
} else {
    if (!isNil QGVAR(acreTxBlock)) then {
        GVAR(acreTxBlock) setVariable ["acre_sys_core_isDisabledRadio", false, true];
        GVAR(acreTxBlock) = nil;
    };
};
