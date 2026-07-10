#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side tint for one acid rain instance: a sickly green color grading
 * that fades in while the player is inside the area and out when leaving. A
 * slow watcher loop manages the post process effect and ends itself once the
 * anchor is deleted.
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

// [anchor, radius, tint, ppHandle, currentBlend]
private _state = [_anchor, _radius, _tint, -1, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_tint", "_ppHandle", "_blend"];

    if (isNull _anchor) exitWith {
        if (_ppHandle != -1) then {
            ppEffectDestroy _ppHandle;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inside = (player distance2D _anchor) < _radius;
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
