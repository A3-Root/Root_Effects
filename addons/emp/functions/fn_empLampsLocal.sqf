#include "..\script_component.hpp"

/*
 * Author: Root
 * Client lamps of an EMP field: street lamps, floodlights and power line lights
 * inside the radius go out one by one as the shockwave reaches them (plus the
 * effect delay), with sparks close to the viewer. Late joiners see them out at
 * once. Lamps mode 1 lights them again when the field ends. Mode 2 flickers them,
 * bursts them (some blow out) and keeps them out. With flickerLamps, dark lamps
 * within 400 m of the viewer that did not blow out flicker at random.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empLampsLocal
 */

params [["_entry", [], [[]]]];
_entry params ["_anchor", "_cfg"];

if (!hasInterface || {(_cfg get "lamps") == 0}) exitWith {};

#define LAMP_CLASSES ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_PowerPoleWooden_L_F", "Land_LampStreet_small_F", "Land_LampHalogen_F", "Land_PortableLight_single_F", "Land_PortableLight_double_F", "Land_FloodLight_F"]
#define FLICKER_RANGE 400

// [entry, pending [time, lamp], dark lamps, mode, blown lamps, next flicker check]
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_pending", "_dark", "_mode", "_blown", "_nextFlicker"];
    _entry params ["_anchor", "_cfg", "", "_detTime"];

    if (isNull _anchor || {_anchor getVariable [QGVAR(ending), false]}) exitWith {
        if (_mode == 1) then {
            {_x switchLight "ON"} forEach (_dark select {!isNull _x});
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _now = CBA_missionTime;
    if (_now < _detTime) exitWith {};
    _args set [3, _cfg get "lamps"];

    // Lamps are listed once at detonation, sorted by the time the wave reaches them.
    if (_dark isEqualTo []) then {
        private _center = getPosASL _anchor;
        private _speed = _cfg get "shockSpeed";
        private _delay = _cfg get "effectDelay";
        private _lamps = nearestObjects [ASLToAGL _center, LAMP_CLASSES, _cfg get "radius", false, true];
        {
            private _time = _detTime + _delay + (if (_speed > 0) then {(_x distance (ASLToAGL _center)) / _speed} else {0});
            _pending pushBack [_time, _x];
        } forEach _lamps;
        _pending sort true;
        _dark pushBack objNull;
        DBG(FORMAT_2("EMP field at %1 darkens %2 lamps",mapGridPosition _anchor,count _lamps));
    };

    private _fresh = _now - _detTime < 60;
    while {_pending isNotEqualTo [] && {(_pending select 0 select 0) <= _now}} do {
        private _lamp = (_pending deleteAt 0) select 1;
        if (!isNull _lamp) then {
            _dark pushBack _lamp;
            if (!_fresh) exitWith {_lamp switchLight "OFF"};
            if (_mode == 2) then {
                // Broken: flickers, then bursts; some blow out.
                private _blowout = random 1 < 0.5;
                if (_blowout) then {_blown pushBack _lamp};
                _lamp switchLight "OFF";
                [{(_this select 0) switchLight "ON"}, [_lamp], 0.08] call CBA_fnc_waitAndExecute;
                [{
                    params ["_lamp", "_blowout"];
                    _lamp switchLight "OFF";
                    [_lamp, _blowout] call FUNC(empSparksLocal);
                }, [_lamp, _blowout], 0.2 + random 0.2] call CBA_fnc_waitAndExecute;
            } else {
                _lamp switchLight "OFF";
                [_lamp, false] call FUNC(empSparksLocal);
            };
        };
    };

    // Flicker for dark lamps near the viewer, picked up every 2 s.
    if (_now >= _nextFlicker && {_cfg getOrDefault ["flickerLamps", false]}) then {
        _args set [5, _now + 2];
        private _viewer = positionCameraToWorld [0, 0, 0];
        {
            if (!isNull _x && {!(_x in _blown)} && {(_x distance _viewer) < FLICKER_RANGE}) then {
                [_x, "lamp", _anchor] call FUNC(empFlickerLocal);
            };
        } forEach _dark;
    };
}, 0.2, [_entry, [], [], _cfg get "lamps", [], 0]] call CBA_fnc_addPerFrameHandler;
