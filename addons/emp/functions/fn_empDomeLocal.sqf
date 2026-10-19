#include "..\script_component.hpp"

/*
 * Author: Root
 * Client dome of an EMP field, growing with the shockwave to the field cap and
 * fading out when the field shuts down:
 * - shell: local tinted glass sphere without collision, seen from outside,
 * - veil: heat haze and faint tinted glow drifting on the surface, seen from
 *   inside and outside, so the edge shows from anywhere,
 * - high quality: denser veil, shimmer and lightning arcs.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entry] call root_effects_emp_fnc_empDomeLocal
 */

params [["_entry", [], [[]]]];

if (!hasInterface || GVAR(domeQuality) == 0) exitWith {};

#define DOME_CLASS "Sign_Sphere200cm_F"
#define DOME_MATERIAL "\A3\Structures_F\Data\Windows\window_set.rvmat"
#define FADE_TIME 2
#define VEIL_RANGE 600

// [entry, shell, fade start, next arc, texture, next veil, attached size]
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_shell", "_fadeStart", "_nextArc", "_texture", "_nextVeil", "_attached"];
    _entry params ["_anchor", "_cfg", "", "_detTime", "_object"];

    if (isNull _anchor) exitWith {
        deleteVehicle _shell;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _now = CBA_missionTime;
    if (_now < _detTime) exitWith {};
    if !(_cfg get "dome") exitWith {
        deleteVehicle _shell;
        _args set [1, objNull];
    };

    private _alpha = _cfg get "domeAlpha";
    private _fade = 1;
    if (_anchor getVariable [QGVAR(ending), false]) then {
        if (_fadeStart < 0) then {
            _fadeStart = _now;
            _args set [2, _now];
        };
        _fade = (1 - (_now - _fadeStart) / FADE_TIME) max 0;
    };
    _alpha = _alpha * _fade;

    private _radius = _cfg get "radius";
    private _speed = _cfg get "shockSpeed";
    private _scale = if (_speed > 0) then {(((_now - _detTime) * _speed) / _radius) min 1} else {1};
    ([_radius, _cfg get "altitude"] call FUNC(empCap)) params ["_sphere", "_offset"];
    _sphere = (_sphere * _scale) max 0.01;
    _offset = _offset * _scale;
    private _center = (getPosASL _anchor) vectorAdd [0, 0, _offset];

    private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
    private _toViewer = (_viewer distance _center) - _sphere;
    if (_toViewer > EGVAR(main,maxViewDistance)) exitWith {
        deleteVehicle _shell;
        _args set [1, objNull];
    };

    // Shell, attached so it can be scaled; it rides on the object when there is one.
    if (isNull _shell) then {
        _shell = DOME_CLASS createVehicleLocal [0, 0, 0];
        _shell enableSimulation false;
        _shell setObjectMaterial [0, DOME_MATERIAL];
        _args set [1, _shell];
        _args set [4, ""];
        _texture = "";
        _attached = -1;
    };
    if (abs (_sphere - _attached) > 0.01) then {
        private _parent = [_anchor, _object] select (!isNull _object);
        _shell attachTo [_parent, _parent worldToModel (ASLToAGL _center)];
        _shell setObjectScale _sphere;
        _args set [6, _sphere];
    };

    private _high = GVAR(domeQuality) == 2;
    private _shimmer = (_cfg get "domeShimmer") && _high;
    private _shellAlpha = _alpha;
    if (_shimmer) then {
        _shellAlpha = _shellAlpha * (0.8 + 0.2 * sin (_now * 90));
    };
    (_cfg get "domeColor") params ["_r", "_g", "_b"];
    // Alpha in steps of 0.005 so the procedural texture changes rarely.
    private _newTexture = format ["#(argb,8,8,3)color(%1,%2,%3,%4)", _r, _g, _b, (round ((_shellAlpha max 0) * 200)) / 200];
    if (_newTexture isNotEqualTo _texture) then {
        _shell setObjectTexture [0, _newTexture];
        _args set [4, _newTexture];
    };

    // Veil on the surface within range of the viewer, sized by distance so it
    // reads the same near and far.
    if (_now >= _nextVeil && _fade > 0 && abs _toViewer < VEIL_RANGE) then {
        _args set [5, _now + 0.1];
        private _budget = (EGVAR(main,particleBudget)) max 0.1;
        private _count = ceil (([4, 10] select _high) * _budget);
        private _veilAlpha = ((_alpha * 4) min 0.25) max 0.03;
        for "_i" from 1 to _count do {
            private _dir = random 360;
            private _pitch = random 80;
            private _point = _center vectorAdd [_sphere * cos _pitch * sin _dir, _sphere * cos _pitch * cos _dir, _sphere * sin _pitch];
            private _distance = _point distance _viewer;
            if ((_point select 2) > getTerrainHeightASL _point && _distance < VEIL_RANGE) then {
                private _size = (_distance * 0.06) max 2;
                private _agl = ASLToAGL _point;
                if (_distance < 250) then {
                    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 3, _agl, [0, 0, 0.2], 0, 1.275, 1, 0, [_size, _size * 1.2],
                        [[1, 1, 1, 0], [1, 1, 1, 0.6 * _fade], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
                };
                drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 0], "", "Billboard", 1, 3, _agl, [0, 0, 0.2], 0, 1.275, 1, 0, [_size, _size * 1.3],
                    [[_r, _g, _b, 0], [_r, _g, _b, _veilAlpha], [_r, _g, _b, 0]], [1], 0, 0, "", "", objNull];
            };
        };
    };

    // Random arcs crawling over the visible surface.
    if (_shimmer && _scale >= 1 && _now >= _nextArc && _fadeStart < 0) then {
        _args set [3, _now + 0.5 + random 2.5];
        private _dir = (_center getDir _viewer) + random 90 - 45;
        private _pitch = random 60;
        private _point = _center vectorAdd [_sphere * cos _pitch * sin _dir, _sphere * cos _pitch * cos _dir, _sphere * sin _pitch];
        if ((_point select 2) > getTerrainHeightASL _point) then {
            drop [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.2 + random 0.2, ASLToAGL _point, [0, 0, 0], 0, 1.275, 1, 0, [4 + random 6],
                [[0.6, 0.8, 1, 0.9], [0.5, 0.7, 1, 0]], [1], 0, 0, "", "", objNull, random 360];
        };
    };
}, 0, [_entry, objNull, -1, 0, "", 0, -1]] call CBA_fnc_addPerFrameHandler;
