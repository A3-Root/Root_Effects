#include "..\script_component.hpp"

/*
 * Author: Root
 * Client lightning riding an EMP wave front: bolts crawling along the front, dense
 * on the stretch facing the viewer, heat haze and blue sparks carried with the wave, a light
 * flicker and crackle at the front point closest to the viewer. Outward the front
 * runs from the center to the radius, inward from the radius to the center.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 * 1: Start time (CBA_missionTime) <NUMBER>
 * 2: Speed in m/s <NUMBER>
 * 3: Inward <BOOL> (optional, default false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry, CBA_missionTime, 50, true] call root_effects_emp_fnc_empFrontLocal
 */

params [["_entry", [], [[]]], ["_start", 0, [0]], ["_speed", 0, [0]], ["_inward", false, [false]]];

if (!hasInterface || _speed <= 0) exitWith {};

// [entry, start, speed, inward, next sound, flash]
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_start", "_speed", "_inward", "_nextSound", "_flash"];
    _entry params ["_anchor", "_cfg"];

    private _radius = _cfg get "radius";
    private _travel = (CBA_missionTime - _start) * _speed;
    private _front = [_travel, _radius - _travel] select _inward;
    if (isNull _anchor || _front < 0 || _front > _radius) exitWith {
        deleteVehicle _flash;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _center = getPosASL _anchor;
    private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
    private _toViewer = _center getDir _viewer;
    private _budget = (EGVAR(main,particleBudget)) max 0.1;
    private _near = _center vectorAdd [_front * sin _toViewer, _front * cos _toViewer, 0];
    _near set [2, (getTerrainHeightASL _near) + 1];
    private _nearDistance = _near distance _viewer;

    for "_i" from 1 to ceil (2 * _budget) do {
        private _dir = [random 360, _toViewer + random 70 - 35] select (random 1 < 0.6);
        private _point = _center vectorAdd [_front * sin _dir, _front * cos _dir, 0];
        private _distance = _point distance _viewer;
        if (_distance < 1500) then {
            _point set [2, (getTerrainHeightASL _point) + 1 + random 4];
            [ASLToAGL _point, 0.08, 0.08 * (1 + _distance / 600), 0.15, 0.03, 0.2] call FUNC(empBoltLocal);
        };
    };

    if (_nearDistance < 600) then {
        // Heat haze on the front facing the viewer.
        for "_i" from 1 to ceil (2 * _budget) do {
            private _dir = _toViewer + random 80 - 40;
            private _point = _center vectorAdd [_front * sin _dir, _front * cos _dir, 0];
            _point set [2, (getTerrainHeightASL _point) + 2 + random 4];
            private _size = 8 + random 12;
            drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1, ASLToAGL _point, [0, 0, 0.5], 0, 1.275, 1, 0, [_size, _size * 1.5],
                [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
        };

        // Sparks thrown with the wave.
        private _out = [_toViewer, _toViewer + 180] select _inward;
        private _velocity = [_speed * 0.3 * sin _out, _speed * 0.3 * cos _out, 2];
        for "_i" from 1 to ceil (6 * _budget) do {
            private _dir = _toViewer + random 60 - 30;
            private _point = _center vectorAdd [_front * sin _dir, _front * cos _dir, 0];
            _point set [2, (getTerrainHeightASL _point) + random 3];
            drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.3 + random 0.4, ASLToAGL _point, _velocity vectorAdd [random 6 - 3, random 6 - 3, random 4], 0, 3, 1, 0.1, [0.25, 0.05],
                [[0.6, 0.85, 1, 1], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull];
        };

        // Light flicker where the front passes closest.
        if (isNull _flash) then {
            _flash = "#lightpoint" createVehicleLocal (ASLToAGL _near);
            _flash setLightColor [0.5, 0.75, 1];
            _flash setLightAmbient [0.3, 0.5, 1];
            _flash setLightDayLight true;
            _flash setLightUseFlare true;
            _flash setLightFlareMaxDistance 1500;
            _args set [5, _flash];
        };
        _flash setPosASL (_near vectorAdd [0, 0, 2]);
        _flash setLightBrightness ([0, 2 + random 6] select (random 1 < 0.5));
        _flash setLightFlareSize (2 + random 4);
    } else {
        deleteVehicle _flash;
    };

    if (CBA_missionTime >= _nextSound) then {
        _args set [4, CBA_missionTime + 0.3 + random 0.4];
        if (_nearDistance < 350) then {
            playSound3D [format [QPATHTOEF(ambientsfx,sounds\spark_%1.ogg), 1 + floor random 7], objNull, false, _near, 3, 0.8 + random 0.4, 350, 0, true];
        };
    };
}, 0.05, [_entry, _start, _speed, _inward, 0, objNull]] call CBA_fnc_addPerFrameHandler;
