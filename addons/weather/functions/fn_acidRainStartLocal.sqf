#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side rain and tint for one acid rain instance: a falling green rain
 * column that follows the player only while inside the area, plus a sickly
 * green colour grading that fades in and out with it. A watcher loop manages
 * the emitter and post process effect and ends itself once the anchor is
 * deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Area radius in meters <NUMBER>
 * 2: Tint strength 0..1 <NUMBER>
 * 3: Rain intensity 0.1 - 1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 500, 0.5, 0.7] call root_effects_weather_fnc_acidRainStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 500, [0]], ["_tint", 0.5, [0]], ["_intensity", 0.7, [0]], ["_weatherRain", false, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

_intensity = (_intensity max 0.1) min 1;

DBG(FORMAT_4("acid rain local start, radius %1, tint %2, intensity %3, weather rain %4",_radius,_tint,_intensity,_weatherRain));

// Rain streaks: the engine's own rain texture on camera-facing billboards, tinted
// sickly green and large enough to read as a real downpour. Weight must stay well
// above volume or the drops float and drift upwards.
private _fnc_rainParams = {
    params ["_emitter", "_intensity"];
    private _alpha = 0.45 + 0.4 * _intensity;
    private _spread = 16 + 14 * _intensity;
    _emitter setParticleCircle [0, [0, 0, 0]];
    _emitter setParticleRandom [0.3, [_spread, _spread, 3], [0.3, 0.3, 2], 0, 0.25, [0.05, 0.1, 0.05, 0.1], 0, 0];
    _emitter setParticleParams [["\A3\data_f\rain_CA.paa", 1, 0, 1], "", "Billboard", 1, 2.2, [0, 0, 0], [0, 0, -14], 0, 20, 1, 0, [0.9 + 0.5 * _intensity], [[0.55, 0.9, 0.2, _alpha], [0.5, 0.85, 0.15, _alpha * 0.85]], [1], 0, 0, "", "", _emitter, 0, true, 0, [[0.5, 0.9, 0.15, _alpha * 0.3]]];
    _emitter setDropInterval ((0.0008 / _intensity) / ((EGVAR(main,particleBudget)) max 0.1));
};

// Engine rain tint for this zone only: rain params are local to each client, so the
// real rain (driven by the server) turns green just for players inside the zone.
private _acidRainParams = [
    "a3\data_f\rain_CA.paa", 1, 0.01, 25, 0.1, 1.2, 0.5, 0.4, 0.025, 0.9,
    [0.45, 0.9, 0.15, 0.55 + 0.35 * _intensity], 0.2, 0.5, 0.5, 0.6, false, true
];

// Low acidic haze hanging over the ground.
private _fnc_mistParams = {
    params ["_emitter", "_intensity"];
    _emitter setParticleCircle [20, [0, 0, 0]];
    _emitter setParticleRandom [3, [20, 20, 1], [0.4, 0.4, 0.1], 0, 0.3, [0, 0.05, 0, 0.05], 0, 0];
    _emitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 8, [0, 0, 0.5], [0, 0, 0.05], 0, 10.1, 7.9, 0.05, [6, 10], [[0.45, 0.6, 0.2, 0], [0.45, 0.6, 0.2, 0.12 * _intensity], [0.45, 0.6, 0.2, 0]], [1], 0, 0, "", "", _emitter];
    _emitter setDropInterval ((0.15 / _intensity) / ((EGVAR(main,particleBudget)) max 0.1));
};

// [anchor, radius, tint, ppHandle, currentBlend, rainEmitter, mistEmitter, covered, intensity, rainFn, mistFn, grainHandle, weatherRain, rainParams, tinted]
private _state = [_anchor, _radius, _tint, -1, 0, objNull, objNull, false, _intensity, _fnc_rainParams, _fnc_mistParams, -1, _weatherRain, _acidRainParams, false];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_tint", "_ppHandle", "_blend", "_rain", "_mist", "_covered", "_intensity", "_fnc_rainParams", "_fnc_mistParams", "_grain", "_weatherRain", "_acidRainParams", "_tinted"];

    if (isNull _anchor) exitWith {
        if (_tinted) then {
            setRain [];
        };
        DBG("acid rain local teardown");
        if (_ppHandle != -1) then {
            ppEffectDestroy _ppHandle;
        };
        if (_grain != -1) then {
            ppEffectDestroy _grain;
        };
        deleteVehicle _rain;
        deleteVehicle _mist;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inside = (player distance2D _anchor) < _radius;

    // Green engine rain only while inside the zone.
    if (_weatherRain && _inside isNotEqualTo _tinted) then {
        if (_inside) then {setRain _acidRainParams} else {setRain []};
        _args set [14, _inside];
    };

    // Rain box that rides above the player's head while inside the zone so the
    // downpour is confined to the area instead of the whole map. Created on
    // entry, moved to follow the camera, and removed on exit.
    if (_inside) then {
        if (isNull _rain) then {
            _rain = "#particlesource" createVehicleLocal (eyePos player);
            [_rain, _intensity] call _fnc_rainParams;
            _args set [5, _rain];

            _mist = "#particlesource" createVehicleLocal (getPosATL player);
            [_mist, _intensity] call _fnc_mistParams;
            _args set [6, _mist];
        };

        // Drops would fall straight through a roof, so the column stops while
        // the player is sheltered and resumes once back outside.
        private _nowCovered = [player] call FUNC(isUnderCover);
        if (_nowCovered isNotEqualTo _covered) then {
            _args set [7, _nowCovered];
            if (_nowCovered) then {
                _rain setDropInterval 0;
            } else {
                [_rain, _intensity] call _fnc_rainParams;
            };
        };

        private _camPos = AGLToASL positionCameraToWorld [0, 0, 0];
        _rain setPosASL (_camPos vectorAdd [0, 0, 22]);
        _mist setPosATL [_camPos select 0, _camPos select 1, 0];
    } else {
        if (!isNull _rain) then {
            deleteVehicle _rain;
            deleteVehicle _mist;
            _args set [5, objNull];
            _args set [6, objNull];
            _args set [7, false];
        };
    };

    private _target = [0, _tint] select _inside;
    if (abs (_blend - _target) < 0.01) exitWith {};

    _blend = _blend + ((_target - _blend) max -0.05 min 0.05);
    _args set [4, _blend];

    if (_ppHandle == -1) then {
        _ppHandle = ppEffectCreate ["ColorCorrections", 1550];
        _ppHandle ppEffectEnable true;
        _args set [3, _ppHandle];

        _grain = ppEffectCreate ["FilmGrain", 2005];
        _grain ppEffectEnable true;
        _args set [11, _grain];
    };

    // Sickly green-yellow grading scaled by the blend factor and darkened by
    // the storm intensity.
    private _dark = 1 - 0.25 * _intensity * _blend;
    _ppHandle ppEffectAdjust [_dark, 1 + 0.1 * _blend, 0, [0.2, 0.35, 0, 0.12 * _blend], [1 - 0.25 * _blend, 1, 1 - 0.5 * _blend, 1 - 0.3 * _blend], [0.5, 0.6, 0.2, 0.15 * _blend]];
    _ppHandle ppEffectCommit 0.5;
    _grain ppEffectAdjust [0.12 * _blend * _intensity, 1, 1.2, 0.4, 0.2, false];
    _grain ppEffectCommit 0.5;
}, 0.25, _state] call CBA_fnc_addPerFrameHandler;
