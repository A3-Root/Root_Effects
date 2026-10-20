#include "..\script_component.hpp"

/*
 * Author: Root
 * Client fog of an EMP field, every 0.25 s while the field has fog on and the
 * viewer is within 300 m of it: low drifting fog puffs inside the dome only,
 * around the viewer when inside, just inside the edge facing the viewer when
 * outside. Opacity from fogAlpha, amount from the fogQuality setting and the
 * particle budget. Weather outside the dome is not touched.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empFogLocal
 */

params [["_entry", [], [[]]]];

if (!hasInterface) exitWith {};

#define FOG_RANGE 300
#define FOG_SPREAD 150

[{
    params ["_args", "_handle"];
    _args params ["_entry"];
    _entry params ["_anchor", "_cfg", "", "_detTime"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };
    if (GVAR(fogQuality) == 0 || CBA_missionTime < _detTime || {!(_cfg getOrDefault ["fog", false])}) exitWith {};
    if (_anchor getVariable [QGVAR(ending), false]) exitWith {};

    private _center = getPosASL _anchor;
    private _radius = _cfg get "radius";
    private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
    private _distance = _viewer distance2D _center;
    if (_distance > _radius + FOG_RANGE) exitWith {};

    private _inside = _distance < _radius;
    private _toViewer = _center getDir _viewer;
    private _alpha = (_cfg get "fogAlpha") * 0.6;
    private _budget = (EGVAR(main,particleBudget)) max 0.1;
    private _count = ceil (([5, 10] select (GVAR(fogQuality) == 2)) * _budget);

    for "_i" from 1 to _count do {
        private _point = if (_inside) then {
            _viewer getPos [5 + random FOG_SPREAD, random 360]
        } else {
            _center getPos [_radius - random 60, _toViewer + random 80 - 40]
        };
        _point set [2, (getTerrainHeightASL _point) + 0.5 + random 4.5];
        if ([_point, _entry, false] call FUNC(empInZone)) then {
            private _size = 15 + random 15;
            drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 10 + random 6, ASLToAGL _point,
                [random 1 - 0.5, random 1 - 0.5, 0], random 1, 1.275, 1, 0, [_size, _size * 1.2],
                [[0.8, 0.81, 0.85, 0], [0.8, 0.81, 0.85, _alpha], [0.8, 0.81, 0.85, _alpha], [0.8, 0.81, 0.85, 0]], [0.05], 0, 0, "", "", objNull];
        };
    };
}, 0.25, [_entry]] call CBA_fnc_addPerFrameHandler;
