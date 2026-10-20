#include "..\script_component.hpp"

/*
 * Author: Root
 * Client detonation of an EMP field: flash, lightning burst, sparks and heat haze
 * at the object, thunder and blast sound, a glowing shock ring and heat haze running
 * out at the shockwave speed with lightning bolts, sparks, light flicker and
 * crackle riding the wave front, and a camera shake when the wave reaches the player.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
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

playSound3D [format ["a3\sounds_f\ambient\thunder\thunder_0%1.wss", 1 + floor random 6], objNull, false, _pos, 5, 0.7, (_radius * 3) max 2000, 0, true];
playSound3D ["a3\sounds_f\weapons\explosion\expl_big_1.wss", objNull, false, _pos, 3, 0.8, 1500, 0, true];
playSound3D [format [QPATHTOEF(ambientsfx,sounds\spark_%1.ogg), 1 + floor random 7], objNull, false, _pos, 5, 0.7, 400, 0, true];

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

// Lightning burst at the object.
[_agl vectorAdd [0, 0, 1], 1.25] call FUNC(empBoltLocal);

// Sparks thrown off the object.
private _sparks = "#particlesource" createVehicleLocal _agl;
_sparks setParticleCircle [0, [0, 0, 0]];
_sparks setParticleRandom [0.5, [0, 0, 0], [50, 50, 50], 0.25, 0, [0, 0, 0, 0], 1, 0];
_sparks setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 1.25, [0, 0, 0], [0, 0, 15], 0, 10, 7.9, 0, [0, 0.25],
    [[1, 1, 0.1, 1], [1, 1, 1, 1]], [1], 1, 0, "", "", _sparks, 0, false, -1, [[1000, 1000, 10000, 1], [0, 0, 1, 0.01]]];
_sparks setDropInterval (0.001 / _budget);
[{deleteVehicle _this}, _sparks, 0.5] call CBA_fnc_waitAndExecute;
for "_i" from 1 to ceil (40 * _budget) do {
    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.6 + random 0.8, _agl vectorAdd [0, 0, 1], [random 16 - 8, random 16 - 8, random 10], 0, 3, 1, 0.1, [0.15, 0.05],
        [[0.7, 0.9, 1, 1], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull];
};

// Heat haze bubble at the object.
for "_i" from 1 to 3 do {
    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1, _agl vectorAdd [random 0.8 - 0.4, random 0.8 - 0.4, 1], [0, 0, 0], 0, 10, 7.9, 0.1, [0, 100],
        [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 1], [0.5, 0.5, 0.5, 1], [0, 0, 0, 1], [0, 0, 0, 0.75], [0, 0, 0, 0.5]], [1], 0.2, 0.2, "", "", objNull];
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
    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, _life, _agl vectorAdd [0, 0, 3], _velocity, 0, 1.275, 1, 0, [10, 25, 40],
        [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
};

[_entry, _detTime, _speed] call FUNC(empFrontLocal);
