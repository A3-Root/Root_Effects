#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one searchlight instance: a local volumetric light
 * beam sweeping the sky in a rising and falling arc, plus an optional
 * recurring air raid alarm. A single loop animates the beam, creates it in
 * range, removes it out of range and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Play a recurring air raid alarm <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, false] call root_effects_battlescripts_fnc_searchlightStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_alarm", false, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, alarm, beamObject, pitch, rotation, rising, nextAlarmTime]
private _state = [_anchor, _alarm, objNull, 30, 10 + random 350, true, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_alarm", "_beam", "_pitch", "_rotation", "_rising", "_nextAlarm"];

    if (isNull _anchor) exitWith {
        deleteVehicle _beam;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inRange = (player distance2D _anchor) < EGVAR(main,maxViewDistance);

    if (_inRange && {isNull _beam}) then {
        _beam = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosASL _anchor, true];
        _args set [2, _beam];
    };

    if (!_inRange && {!isNull _beam}) then {
        deleteVehicle _beam;
        _args set [2, objNull];
    };

    if (!isNull _beam) then {
        // Sweep upward across the sky, pause, then swing back down.
        if (_rising) then {
            _pitch = _pitch + 0.6;
            _rotation = _rotation - 0.6;
            if (_pitch >= 150) then {
                _args set [5, false];
            };
        } else {
            _pitch = _pitch - 0.6;
            _rotation = _rotation + 3;
            if (_pitch <= 30) then {
                _args set [5, true];
            };
        };
        _args set [3, _pitch];
        _args set [4, _rotation];

        private _pitchAngle = -_pitch;
        private _yawAngle = (360 - _rotation) - 360;
        private _dir = [sin _yawAngle * cos _pitchAngle, cos _yawAngle * cos _pitchAngle, sin _pitchAngle];
        private _up = [sin _yawAngle * -(sin _pitchAngle), cos _yawAngle * -(sin _pitchAngle), cos _pitchAngle];
        _beam setVectorDirAndUp [_dir, _up];
    };

    if (_alarm && _inRange && {CBA_missionTime >= _nextAlarm}) then {
        _anchor say3D [QGVAR(air_raid_siren), 3000];
        _args set [6, CBA_missionTime + 30];
    };
}, 0.03, _state] call CBA_fnc_addPerFrameHandler;
