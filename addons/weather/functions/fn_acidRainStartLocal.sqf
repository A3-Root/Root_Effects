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
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 500, 0.5] call root_effects_weather_fnc_acidRainStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 500, [0]], ["_tint", 0.5, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, radius, tint, ppHandle, currentBlend, rainEmitter]
private _state = [_anchor, _radius, _tint, -1, 0, objNull];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_tint", "_ppHandle", "_blend", "_rain"];

    if (isNull _anchor) exitWith {
        if (_ppHandle != -1) then {
            ppEffectDestroy _ppHandle;
        };
        if (!isNull _rain) then {
            deleteVehicle _rain;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inside = (player distance2D _anchor) < _radius;

    // Rain box that rides above the player's head while inside the zone so the
    // downpour is confined to the area instead of the whole map. Created on
    // entry, moved to follow the camera, and removed on exit.
    if (_inside) then {
        if (isNull _rain) then {
            _rain = "#particlesource" createVehicleLocal (eyePos player);
            _rain setParticleCircle [0, [0, 0, 0]];
            _rain setParticleRandom [0.2, [22, 22, 0], [0.5, 0.5, 1], 0, 0, [0, 0, 0, 0], 0, 0];
            _rain setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 7, 1], "", "SpaceObject", 1, 1, [0, 0, 0], [0, 0, -22], 1, 0.004, 0.5, 1, [0.04, 0.02], [[0.45, 0.6, 0.2, 0.55], [0.4, 0.55, 0.18, 0.35]], [1], 1, 0, "", "", _rain];
            _rain setDropInterval (0.0015 / ((EGVAR(main,particleBudget)) max 0.1));
            _args set [5, _rain];
        };
        _rain setPosATL ((eyePos player) vectorAdd [0, 0, 16]);
    } else {
        if (!isNull _rain) then {
            deleteVehicle _rain;
            _args set [5, objNull];
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
    };

    // Sickly green-yellow grading scaled by the blend factor.
    _ppHandle ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1 - 0.2 * _blend, 1, 1 - 0.4 * _blend, 1 - 0.2 * _blend], [0.5, 0.6, 0.2, 0.1 * _blend]];
    _ppHandle ppEffectCommit 0.5;
}, 0.5, _state] call CBA_fnc_addPerFrameHandler;
