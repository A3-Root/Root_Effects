#include "..\script_component.hpp"

/*
 * Author: Root
 * Client implosion of an EMP field: glow and heat haze running in from the edge
 * to the center, lightning arcs on the collapsing dome, then flash and blast
 * sound at the center and camera shake nearby (shake) after IMPLODE_TIME.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empImplodeLocal
 */

params [["_entry", [], [[]]]];
_entry params ["_anchor", "_cfg"];

if (!hasInterface || {isNull _anchor}) exitWith {};

private _pos = getPosASL _anchor;
private _radius = _cfg get "radius";
private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
if ((_viewer distance _pos) > ((EGVAR(main,maxViewDistance) max (_radius * 2)) max 1500)) exitWith {};
DBG(FORMAT_1("EMP implosion visuals at %1",mapGridPosition _anchor));

private _agl = ASLToAGL _pos;
private _budget = (EGVAR(main,particleBudget)) max 0.1;

playSound3D [format ["a3\sounds_f\ambient\thunder\thunder_0%1.wss", 1 + floor random 6], objNull, false, _pos, 4, 0.5, (_radius * 3) max 2000, 0, true];

// Inward ring: glow and haze from the edge to the center.
private _speed = _radius / IMPLODE_TIME;
private _count = ceil (48 * _budget) max 12;
for "_i" from 0 to (_count - 1) do {
    private _dir = 360 * _i / _count;
    private _start = _agl vectorAdd [_radius * sin _dir, _radius * cos _dir, 2];
    private _velocity = [-_speed * sin _dir, -_speed * cos _dir, 0];
    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, IMPLODE_TIME, _start, _velocity, 0, 1.275, 1, 0, [20, 12, 4],
        [[0.3, 0.5, 1, 0], [0.4, 0.6, 1, 0.3], [0.5, 0.75, 1, 0.5]], [1], 0, 0, "", "", objNull];
    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, IMPLODE_TIME, _start vectorAdd [0, 0, 1], _velocity, 0, 1.275, 1, 0, [30, 20, 8],
        [[1, 1, 1, 0], [1, 1, 1, 0.6]], [1], 0, 0, "", "", objNull];
};

// Lightning arcs on the shrinking dome.
for "_i" from 1 to 8 do {
    [{
        params ["_agl", "_radius", "_progress", "_budget"];
        private _shell = _radius * (1 - _progress * _progress);
        for "_j" from 1 to ceil (6 * _budget) do {
            private _dir = random 360;
            private _pitch = random 70;
            private _point = _agl vectorAdd [_shell * cos _pitch * sin _dir, _shell * cos _pitch * cos _dir, _shell * sin _pitch];
            drop [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.1 + random 0.2, _point, [0, 0, 0], random 360, 1.275, 1, 0, [(8 + random 10) * (1 + _shell / 300)],
                [[0.6, 0.8, 1, 0.9], [0.5, 0.7, 1, 0.6], [0.5, 0.7, 1, 0]], [1], 0, 0, "", "", objNull, random 360];
        };
    }, [_agl, _radius, _i / 9, _budget], IMPLODE_TIME * _i / 9] call CBA_fnc_waitAndExecute;
};

// Collapse: flash and blast at the center.
[{
    params ["_agl", "_pos", "_radius", "_shake"];
    playSound3D ["a3\sounds_f\weapons\explosion\expl_big_1.wss", objNull, false, _pos, 3, 0.9, 1500, 0, true];
    playSound3D [format [QPATHTOEF(ambientsfx,sounds\spark_%1.ogg), 1 + floor random 7], objNull, false, _pos, 5, 0.7, 400, 0, true];
    private _flash = "#lightpoint" createVehicleLocal (_agl vectorAdd [0, 0, 3]);
    _flash setLightColor [0.6, 0.8, 1];
    _flash setLightAmbient [0.5, 0.7, 1];
    _flash setLightBrightness 30;
    _flash setLightDayLight true;
    _flash setLightUseFlare true;
    _flash setLightFlareSize 20;
    _flash setLightFlareMaxDistance 3000;
    [{deleteVehicle _this}, _flash, 0.4] call CBA_fnc_waitAndExecute;
    for "_i" from 1 to 30 do {
        drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.6 + random 0.8, _agl vectorAdd [0, 0, 1], [random 16 - 8, random 16 - 8, random 10], 0, 3, 1, 0.1, [0.15, 0.05],
            [[0.7, 0.9, 1, 1], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull];
    };
    if (_shake && {((getPosASL player) distance _pos) <= ((_radius * 0.5) max 50)}) then {
        addCamShake [8, 1.5, 25];
    };
}, [_agl, _pos, _radius, _cfg get "shake"], IMPLODE_TIME] call CBA_fnc_waitAndExecute;
