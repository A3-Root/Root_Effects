#include "..\script_component.hpp"

/*
 * Author: Root
 * Client detonation of an EMP field: flash, lightning arcs and sparks at the
 * object, thunder and blast sound, a glowing shock ring and heat haze running
 * out at the shockwave speed with lightning bolts and crackle riding the wave
 * front, and a camera shake when the wave reaches the player.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empDetonateLocal
 */

params [["_entry", [], [[]]]];
_entry params ["_anchor", "_cfg", "", "_detTime"];

if (!hasInterface || {isNull _anchor}) exitWith {};

private _pos = getPosASL _anchor;
private _radius = _cfg get "radius";
private _speed = _cfg get "shockSpeed";
private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
private _distance = _viewer distance _pos;

if (_distance > ((EGVAR(main,maxViewDistance) max (_radius * 2)) max 1500)) exitWith {};
DBG(FORMAT_2("EMP detonation visuals at %1, viewer %2 m away",mapGridPosition _anchor,round _distance));

playSound3D [format ["a3\sounds_f\ambient\thunder\thunder_0%1.wss", 1 + floor random 6], objNull, false, _pos, 5, 0.7, (_radius * 3) max 2000];
playSound3D ["a3\sounds_f\weapons\explosion\expl_big_1.wss", objNull, false, _pos, 3, 0.8, 1500];
playSound3D ["a3\sounds_f\weapons\mines\electron_activate_mine_1.wss", objNull, false, _pos, 4, 0.6, 300];

// Camera shake as the wave rolls over the player.
if (_cfg get "shake") then {
    private _playerDistance = (getPosASL player) distance _pos;
    if (_playerDistance <= _radius * 1.2) then {
        private _delay = if (_speed > 0) then {_playerDistance / _speed} else {0};
        [{
            params ["_strength"];
            addCamShake [_strength, 1.5, 30];
        }, [linearConversion [0, _radius, _playerDistance, 12, 3, true]], _delay] call CBA_fnc_waitAndExecute;
    };
};

if !(_cfg get "visuals") exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;
private _agl = ASLToAGL _pos;

// Flash.
private _flash = "#lightpoint" createVehicleLocal (_agl vectorAdd [0, 0, 3]);
_flash setLightColor [0.6, 0.8, 1];
_flash setLightAmbient [0.5, 0.7, 1];
_flash setLightBrightness 40;
_flash setLightDayLight true;
_flash setLightUseFlare true;
_flash setLightFlareSize 30;
_flash setLightFlareMaxDistance 5000;
[{
    params ["_args", "_handle"];
    _args params ["_flash", "_start"];
    private _t = CBA_missionTime - _start;
    if (_t > 0.8) exitWith {
        deleteVehicle _flash;
        _handle call CBA_fnc_removePerFrameHandler;
    };
    _flash setLightBrightness (40 * (1 - _t / 0.8) + random 4);
}, 0, [_flash, CBA_missionTime]] call CBA_fnc_addPerFrameHandler;

// Lightning arcs around the object, in a few bursts.
private _fnc_arcs = {
    params ["_pos", "_count"];
    for "_i" from 1 to _count do {
        private _offset = [random 16 - 8, random 16 - 8, random 6];
        drop [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.15 + random 0.25, _pos vectorAdd _offset, [0, 0, 0], 0, 1.275, 1, 0, [1.5 + random 2.5],
            [[0.7, 0.85, 1, 1], [0.5, 0.7, 1, 0.6], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull, random 360];
    };
};
[_agl, ceil (10 * _budget)] call _fnc_arcs;
for "_i" from 1 to 3 do {
    [_fnc_arcs, [_agl, ceil (5 * _budget)], 0.15 * _i + random 0.2] call CBA_fnc_waitAndExecute;
};

// Sparks thrown off the object.
for "_i" from 1 to ceil (40 * _budget) do {
    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.6 + random 0.8, _agl vectorAdd [0, 0, 1], [random 16 - 8, random 16 - 8, random 10], 0, 3, 1, 0.1, [0.15, 0.05],
        [[0.7, 0.9, 1, 1], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull];
};

// Shock ring: glow and haze running out along the ground at the wave speed.
if (_speed <= 0) exitWith {};
private _life = (_radius / _speed) min 15;
private _ringSpeed = _radius / (_life max 0.1);
private _count = ceil (48 * _budget) max 12;
for "_i" from 0 to (_count - 1) do {
    private _dir = 360 * _i / _count;
    private _velocity = [_ringSpeed * sin _dir, _ringSpeed * cos _dir, 0];
    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, _life, _agl vectorAdd [0, 0, 2], _velocity, 0, 1.275, 1, 0, [4, 12, 20],
        [[0.5, 0.75, 1, 0.5], [0.4, 0.6, 1, 0.3], [0.3, 0.5, 1, 0]], [1], 0, 0, "", "", objNull];
    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, _life, _agl vectorAdd [0, 0, 3], _velocity, 0, 1.275, 1, 0, [8, 20, 30],
        [[1, 1, 1, 0.6], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
};

// Lightning bolts along the wave front, denser towards the viewer, and crackle
// from the front point closest to the viewer as it passes.
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_nextSound"];
    _entry params ["_anchor", "_cfg", "", "_detTime"];

    private _speed = _cfg get "shockSpeed";
    private _front = (CBA_missionTime - _detTime) * _speed;
    if (isNull _anchor || _speed <= 0 || {_front > _cfg get "radius"}) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _center = getPosASL _anchor;
    private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
    private _toViewer = _center getDir _viewer;
    private _budget = (EGVAR(main,particleBudget)) max 0.1;

    for "_i" from 1 to ceil (6 * _budget) do {
        private _dir = [random 360, _toViewer + random 60 - 30] select (random 1 < 0.5);
        private _point = _center vectorAdd [_front * sin _dir, _front * cos _dir, 0];
        _point set [2, (getTerrainHeightASL _point) + random 4];
        private _distance = _point distance _viewer;
        if (_distance < 1500) then {
            drop [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.1 + random 0.2, ASLToAGL _point, [0, 0, 0], 0, 1.275, 1, 0, [(1.5 + random 3) * (1 + _distance / 400)],
                [[0.7, 0.85, 1, 1], [0.5, 0.7, 1, 0.5], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull, random 360];
        };
    };

    if (CBA_missionTime >= _nextSound) then {
        _args set [1, CBA_missionTime + 0.25 + random 0.3];
        private _point = _center vectorAdd [_front * sin _toViewer, _front * cos _toViewer, 0];
        _point set [2, (getTerrainHeightASL _point) + 1];
        if ((_point distance _viewer) < 400) then {
            playSound3D [selectRandom ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", "a3\sounds_f\weapons\mines\electron_activate_mine_1.wss"], objNull, false, _point, 2.5, 0.8 + random 0.5, 350];
        };
    };
}, 0.1, [_entry, 0]] call CBA_fnc_addPerFrameHandler;
