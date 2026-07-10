#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side tint for one water tint zone: a color grading that appears
 * while the player is inside the zone and doubles in intensity underwater,
 * selling the impression of contaminated water. A watcher loop manages the
 * post process effect and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Zone radius in meters <NUMBER>
 * 2: Color index: 0 blood red, 1 toxic green, 2 ink black <NUMBER>
 * 3: Tint strength 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 500, 0, 0.6] call root_effects_weather_fnc_waterTintStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 500, [0]], ["_colorIndex", 0, [0]], ["_strength", 0.6, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

private _tintColor = [[0.6, 0.05, 0.05], [0.25, 0.6, 0.1], [0.08, 0.08, 0.1]] param [_colorIndex, [0.6, 0.05, 0.05]];

// [anchor, radius, tintColor, strength, ppHandle, currentBlend]
private _state = [_anchor, _radius, _tintColor, _strength, -1, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_tintColor", "_strength", "_ppHandle", "_blend"];

    if (isNull _anchor) exitWith {
        if (_ppHandle != -1) then {
            ppEffectDestroy _ppHandle;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inside = (player distance2D _anchor) < _radius;
    private _target = 0;
    if (_inside) then {
        // Above water the tint is a hint; submerged it takes over.
        _target = [_strength * 0.35, _strength] select (underwater player);
    };

    if (abs (_blend - _target) < 0.01 && {_ppHandle != -1 || {_target == 0}}) exitWith {};

    _blend = _blend + ((_target - _blend) max -0.08 min 0.08);
    _args set [5, _blend];

    if (_ppHandle == -1) then {
        _ppHandle = ppEffectCreate ["ColorCorrections", 1551];
        _ppHandle ppEffectEnable true;
        _args set [4, _ppHandle];
    };

    _tintColor params ["_red", "_green", "_blue"];
    _ppHandle ppEffectAdjust [1, 1, 0, [_red * 0.1 * _blend, _green * 0.1 * _blend, _blue * 0.1 * _blend, 0], [1 - _blend * (1 - _red), 1 - _blend * (1 - _green), 1 - _blend * (1 - _blue), 1], [0.5, 0.5, 0.5, 0.1 * _blend]];
    _ppHandle ppEffectCommit 0.5;

    if (_blend <= 0.01 && {_target == 0}) then {
        ppEffectDestroy _ppHandle;
        _args set [4, -1];
        _args set [5, 0];
    };
}, 0.5, _state] call CBA_fnc_addPerFrameHandler;
