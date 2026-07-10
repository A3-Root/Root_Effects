#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side haze for one heat mirage zone: a pulsing blur with heat
 * shimmer particles around the player while inside the zone. A watcher loop
 * fades the effect in and out at the zone edge and ends itself once the
 * anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Zone radius in meters <NUMBER>
 * 2: Haze intensity 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 200, 0.5] call root_effects_weather_fnc_mirageStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 200, [0]], ["_intensity", 0.5, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, radius, intensity, ppHandle, shimmerEmitter, phase]
private _state = [_anchor, _radius, _intensity, -1, objNull, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_intensity", "_ppHandle", "_shimmer", "_phase"];

    if (isNull _anchor) exitWith {
        if (_ppHandle != -1) then {
            ppEffectDestroy _ppHandle;
        };
        deleteVehicle _shimmer;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inside = (player distance2D _anchor) < _radius;

    if (_inside) then {
        if (_ppHandle == -1) then {
            _ppHandle = ppEffectCreate ["DynamicBlur", 460];
            _ppHandle ppEffectEnable true;
            _args set [3, _ppHandle];
        };
        if (isNull _shimmer) then {
            private _heatShimmer = "#particlesource" createVehicleLocal (player getPos [10, getDir player]);
            _heatShimmer setParticleCircle [8, [0, 0, 0]];
            _heatShimmer setParticleRandom [1, [6, 6, 1], [0, 0, 1], 0, 0.3, [0, 0, 0, 0], 0, 0];
            _heatShimmer setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 1], [0, 0, 1.5], 0, 9, 7, 0, [3, 6], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", player];
            _heatShimmer setDropInterval 0.1;
            _args set [4, _heatShimmer];
        } else {
            _shimmer setPos (player getPos [10, getDir player]);
        };

        // Slow sine pulse so the blur waves like rising heat.
        _phase = _phase + 0.35;
        _args set [5, _phase];
        _ppHandle ppEffectAdjust [_intensity * (0.35 + 0.3 * (0.5 + 0.5 * sin (_phase * 57.3)))];
        _ppHandle ppEffectCommit 0.4;
    } else {
        if (_ppHandle != -1) then {
            ppEffectDestroy _ppHandle;
            _args set [3, -1];
        };
        if (!isNull _shimmer) then {
            deleteVehicle _shimmer;
            _args set [4, objNull];
        };
    };
}, 0.4, _state] call CBA_fnc_addPerFrameHandler;
