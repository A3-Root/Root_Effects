#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one searchlight instance: a local volumetric light
 * beam, plus an optional recurring air raid alarm. Free standing lights sweep
 * the sky in a rising and falling arc. A light mounted on an object rides on
 * top of it and, when that object has a turret with a gunner in it, points
 * wherever the gunner aims. A single loop animates the beam, creates it in
 * range, removes it out of range and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Play a recurring air raid alarm <BOOL>
 * 2: Object the beam is mounted on, objNull for a free standing light <OBJECT>
 * 3: Sweep automatically while the mount has no gunner <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, false, objNull, true] call root_effects_battlescripts_fnc_searchlightStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_alarm", false, [false]], ["_attachTo", objNull, [objNull]], ["_aiSearch", true, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// Turret aim can only be read off a crewed turret; without one there is
// nothing to follow and the light falls back to sweeping or sitting still.
private _turreted = _attachTo isNotEqualTo objNull && {((configOf _attachTo) >> "Turrets") isNotEqualTo configNull} && {count ("true" configClasses ((configOf _attachTo) >> "Turrets")) > 0};

// [anchor, alarm, beamObject, pitch, rotation, rising, nextAlarmTime, attachTo, aiSearch, turreted]
private _state = [_anchor, _alarm, objNull, 30, 10 + random 350, true, 0, _attachTo, _aiSearch, _turreted];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_alarm", "_beam", "_pitch", "_rotation", "_rising", "_nextAlarm", "_attachTo", "_aiSearch", "_turreted"];

    if (isNull _anchor) exitWith {
        deleteVehicle _beam;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // A mount that is destroyed or deleted takes its light with it.
    private _mounted = !isNull _attachTo;
    if (_mounted && {!alive _attachTo}) exitWith {
        deleteVehicle _beam;
        _args set [2, objNull];
    };

    private _origin = [_anchor, _attachTo] select _mounted;
    private _inRange = (player distance2D _origin) < EGVAR(main,maxViewDistance);

    if (_inRange && {isNull _beam}) then {
        _beam = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosASL _origin, true];
        _args set [2, _beam];
    };

    if (!_inRange && {!isNull _beam}) then {
        deleteVehicle _beam;
        _args set [2, objNull];
    };

    if (isNull _beam) exitWith {};

    if (_mounted) then {
        // Ride on top of the mount; it may be driving around.
        private _bbox = boundingBoxReal _attachTo;
        private _top = ((_bbox select 1) select 2) max 0.5;
        _beam setPosASL ((getPosASL _attachTo) vectorAdd [0, 0, _top]);
    };

    // Crew can mount or leave at any time, so the mode is re-checked each tick
    // rather than locked in at creation.
    private _gunner = objNull;
    if (_turreted) then {
        _gunner = _attachTo turretUnit [0];
    };
    private _followAim = !isNull _gunner;

    if (_followAim) then {
        // Pure local read of where the gunner is looking; no network traffic.
        private _dir = _gunner weaponDirection (currentWeapon _gunner);
        if (_dir isEqualTo [0, 0, 0]) then {
            _dir = vectorDir _attachTo;
        };

        // Build an up vector orthogonal to the aim so the cone is not rolled.
        private _right = _dir vectorCrossProduct [0, 0, 1];
        if ((vectorMagnitude _right) < 0.001) then {
            _right = vectorDir _attachTo vectorCrossProduct [0, 0, 1];
        };
        private _up = _right vectorCrossProduct _dir;

        // The volumetric cone projects along the model's negative direction axis,
        // so the direction is inverted to make the shaft shine where the turret aims.
        _beam setVectorDirAndUp [vectorNormalized (_dir vectorMultiply -1), vectorNormalized _up];
    } else {
        private _sweeping = !_mounted || _aiSearch;

        if (_sweeping) then {
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
        } else {
            // Parked light: fixed shaft along the way the mount faces.
            _pitch = 45;
            _rotation = getDir _attachTo;
        };

        private _pitchAngle = -_pitch;
        private _yawAngle = (360 - _rotation) - 360;
        private _dir = [sin _yawAngle * cos _pitchAngle, cos _yawAngle * cos _pitchAngle, sin _pitchAngle];
        private _up = [sin _yawAngle * -(sin _pitchAngle), cos _yawAngle * -(sin _pitchAngle), cos _pitchAngle];
        _beam setVectorDirAndUp [_dir, _up];
    };

    if (_alarm && _inRange && {CBA_missionTime >= _nextAlarm}) then {
        _origin say3D [QGVAR(air_raid_siren), 3000];
        _args set [6, CBA_missionTime + 30];
    };
}, 0.03, _state] call CBA_fnc_addPerFrameHandler;
