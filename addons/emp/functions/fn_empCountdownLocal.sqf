#include "..\script_component.hpp"

/*
 * Author: Root
 * Client countdown of an EMP field: beeping from the object that speeds up
 * towards zero, a 3D timer over the object, an optional hint inside the radius,
 * and an optional blue glow charging up over the last 3 seconds.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empCountdownLocal
 */

params [["_entry", [], [[]]]];
_entry params ["_anchor", "", "", "_detTime"];

if (!hasInterface || CBA_missionTime >= _detTime) exitWith {};

#define BEEP_SOUND "a3\sounds_f\arsenal\tools\MineDetector_Beep_01.wss"
#define TIMER_RANGE 300

if (GVAR(showCountdown3D)) then {
    private _id = addMissionEventHandler ["Draw3D", {
        _thisArgs params ["_entry"];
        _entry params ["_anchor", "_cfg", "", "_detTime"];
        if (isNull _anchor || CBA_missionTime >= _detTime || {_anchor getVariable [QGVAR(ending), false]}) exitWith {
            removeMissionEventHandler [_thisEvent, _thisEventHandler];
        };
        if !(_cfg get "timer3D") exitWith {};
        private _pos = ASLToAGL getPosASL _anchor;
        private _distance = _pos distance (positionCameraToWorld [0, 0, 0]);
        if (_distance > TIMER_RANGE) exitWith {};
        private _left = ceil (_detTime - CBA_missionTime);
        drawIcon3D ["", [0.5, 0.8, 1, linearConversion [0, TIMER_RANGE, _distance, 1, 0.3, true]], _pos vectorAdd [0, 0, 1.5], 0, 0, 0,
            format ["EMP %1:%2", floor (_left / 60), [_left mod 60, 2] call CBA_fnc_formatNumber], 2, 0.04, "PuristaBold", "center"];
    }, [_entry]];
    DBG(FORMAT_1("EMP countdown display handler %1",_id));
};

// [entry, next beep, last hint second, glow]
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_nextBeep", "_lastHint", "_glow"];
    _entry params ["_anchor", "_cfg", "", "_detTime"];

    private _now = CBA_missionTime;
    if (isNull _anchor || _now >= _detTime || {_anchor getVariable [QGVAR(ending), false]}) exitWith {
        deleteVehicle _glow;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _left = _detTime - _now;
    private _pos = getPosASL _anchor;

    if ((_cfg get "beep") && _now >= _nextBeep) then {
        playSound3D [BEEP_SOUND, objNull, false, _pos vectorAdd [0, 0, 1], 2, 1 + (linearConversion [10, 0, _left, 0, 0.5, true]), 120];
        _args set [1, _now + linearConversion [10, 0, _left, 1, 0.15, true]];
    };

    if (_cfg get "timerHint" && {floor _left != _lastHint} && {(player distance2D (ASLToAGL _pos)) <= (_cfg get "radius")}) then {
        hintSilent format [LLSTRING(CountdownHint), ceil _left];
        _args set [2, floor _left];
    };

    if (_left <= 3 && {_cfg get "chargeGlow"}) then {
        if (isNull _glow) then {
            _glow = "#lightpoint" createVehicleLocal (ASLToAGL _pos);
            _glow setLightColor [0.4, 0.7, 1];
            _glow setLightAmbient [0.2, 0.4, 1];
            _glow setLightUseFlare true;
            _glow setLightFlareSize 2;
            _glow setLightFlareMaxDistance 1500;
            _glow setLightDayLight true;
            _args set [3, _glow];
        };
        _glow setPosASL (_pos vectorAdd [0, 0, 1.5]);
        private _charge = linearConversion [3, 0, _left, 0, 1, true];
        _glow setLightBrightness (0.5 + 6 * _charge + random _charge);
        _glow setLightFlareSize (2 + 10 * _charge);
    };
}, 0.05, [_entry, 0, -1, objNull]] call CBA_fnc_addPerFrameHandler;
