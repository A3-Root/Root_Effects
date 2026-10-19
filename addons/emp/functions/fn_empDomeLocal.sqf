#include "..\script_component.hpp"

/*
 * Author: Root
 * Client dome of an EMP field, growing with the shockwave to the field cap and
 * fading out when the field shuts down:
 * - shell: local tinted glass sphere without collision, seen from outside,
 * - inner shell: tinted glass panels laid on the cap, built while the viewer is
 *   inside, so the dome shows from inside the same as from outside,
 * - veil: faint tinted glow drifting on the surface near the viewer,
 * - domeMirage: heat haze on the surface only, densest where it meets the ground,
 * - domeLightning: lightning arcs flashing at random on the surface in view,
 * - high quality: denser veil and haze, shimmer, arc flashes.
 *
 * Arguments:
 * 0: Field entry [anchor, settings, version, detonation time, object, interact] <ARRAY>
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
#define PANEL_CLASS "UserTexture10m_F"
#define PANEL_SIZE 10
#define FADE_TIME 2
#define VEIL_RANGE 600
#define HAZE_RANGE 300

// [entry, shell, fade start, next arc, texture, next veil, attached size, panels, panel key]
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_shell", "_fadeStart", "_nextArc", "_texture", "_nextVeil", "_attached", "_panels", "_panelKey"];
    _entry params ["_anchor", "_cfg", "", "_detTime", "_object"];

    private _fnc_clearPanels = {
        {deleteVehicle _x} forEach _panels;
        _panels resize 0;
        _args set [8, []];
    };

    if (isNull _anchor) exitWith {
        deleteVehicle _shell;
        call _fnc_clearPanels;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _now = CBA_missionTime;
    if (_now < _detTime) exitWith {};
    if !(_cfg get "dome") exitWith {
        deleteVehicle _shell;
        _args set [1, objNull];
        call _fnc_clearPanels;
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
    private _altitude = _cfg get "altitude";
    private _speed = _cfg get "shockSpeed";
    private _scale = if (_speed > 0) then {(((_now - _detTime) * _speed) / _radius) min 1} else {1};
    ([_radius, _altitude] call FUNC(empCap)) params ["_sphere", "_offset"];
    private _fullSphere = _sphere;
    private _fullOffset = _offset;
    _sphere = (_sphere * _scale) max 0.01;
    _offset = _offset * _scale;
    private _center = (getPosASL _anchor) vectorAdd [0, 0, _offset];

    private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
    private _toViewer = (_viewer distance _center) - _sphere;
    if (_toViewer > EGVAR(main,maxViewDistance)) exitWith {
        deleteVehicle _shell;
        _args set [1, objNull];
        call _fnc_clearPanels;
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
    private _textureChanged = _newTexture isNotEqualTo _texture;
    if (_textureChanged) then {
        _shell setObjectTexture [0, _newTexture];
        _args set [4, _newTexture];
    };

    // Inner shell while the viewer is inside the full grown dome: rings of panels
    // from the ground to the top, each pair back to back so one faces the viewer.
    private _inside = _toViewer < 0 && _scale >= 1 && _fade > 0;
    if (_inside) then {
        private _rings = [3, 5] select _high;
        // Rebuilt when the cap changes or the dome moved 10 m with its object.
        private _key = [_fullSphere, _fullOffset, _rings, _center apply {round (_x / 10)}];
        if (_key isNotEqualTo _panelKey) then {
            call _fnc_clearPanels;
            _args set [8, _key];
            private _base = asin (((-_fullOffset / _fullSphere) max -1) min 1);
            private _step = (90 - _base) / _rings;
            for "_ring" from 0 to (_rings - 1) do {
                private _pitch = _base + _step * (_ring + 0.5);
                private _count = (round (360 * cos _pitch / _step)) max 3;
                private _size = (_fullSphere * rad _step * 1.08) max ((2 * pi * _fullSphere * cos (_base + _step * _ring) / _count) * 1.08);
                for "_i" from 0 to (_count - 1) do {
                    private _dir = 360 * (_i + 0.5) / _count;
                    private _normal = [cos _pitch * sin _dir, cos _pitch * cos _dir, sin _pitch];
                    private _up = [-(sin _pitch) * sin _dir, -(sin _pitch) * cos _dir, cos _pitch];
                    private _pos = _center vectorAdd (_normal vectorMultiply _fullSphere);
                    {
                        private _panel = createSimpleObject [PANEL_CLASS, _pos, true];
                        _panel setObjectScale (_size / PANEL_SIZE);
                        _panel setPosWorld _pos;
                        _panel setVectorDirAndUp [_normal vectorMultiply _x, _up];
                        _panels pushBack _panel;
                    } forEach [1, -1];
                };
            };
            _textureChanged = true;
            DBG(FORMAT_2("EMP inner dome at %1: %2 panels",mapGridPosition _anchor,count _panels));
        };
        if (_textureChanged) then {
            {_x setObjectTexture [0, _newTexture]} forEach _panels;
        };
    } else {
        if (_panels isNotEqualTo []) then {call _fnc_clearPanels};
    };

    // Direction the surface effects favour: the camera heading inside, the viewer outside.
    private _facing = if (_toViewer < 0) then {
        private _look = (AGLToASL (positionCameraToWorld [0, 0, 1])) vectorDiff _viewer;
        (_look select 0) atan2 (_look select 1)
    } else {
        (getPosASL _anchor) getDir _viewer
    };
    private _groundPitch = asin ((((-_offset) / _sphere) max -1) min 1);

    // Veil and haze on the surface within range of the viewer, sized by distance so
    // they read the same near and far; the haze crowds the ground line.
    if (_now >= _nextVeil && _fade > 0 && abs _toViewer < VEIL_RANGE) then {
        _args set [5, _now + 0.1];
        private _budget = (EGVAR(main,particleBudget)) max 0.1;
        private _count = ceil (([4, 10] select _high) * _budget);
        private _mirage = _cfg getOrDefault ["domeMirage", true];
        private _veilAlpha = ((_alpha * 4) min 0.25) max 0.03;
        for "_i" from 1 to _count do {
            private _dir = [random 360, _facing + random 90 - 45] select (random 1 < 0.6);
            private _pitch = [_groundPitch + random (80 - _groundPitch), _groundPitch + random 8] select (random 1 < 0.5);
            private _point = _center vectorAdd [_sphere * cos _pitch * sin _dir, _sphere * cos _pitch * cos _dir, _sphere * sin _pitch];
            private _distance = _point distance _viewer;
            if ((_point select 2) > getTerrainHeightASL _point && _distance < VEIL_RANGE) then {
                private _size = (_distance * 0.06) max 2;
                private _agl = ASLToAGL _point;
                if (_mirage && _distance < HAZE_RANGE) then {
                    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 3, _agl, [0, 0, 0.2], 0, 1.275, 1, 0, [_size, _size * 1.2],
                        [[1, 1, 1, 0], [1, 1, 1, 0.6 * _fade], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
                };
                drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 0], "", "Billboard", 1, 3, _agl, [0, 0, 0.2], 0, 1.275, 1, 0, [_size, _size * 1.3],
                    [[_r, _g, _b, 0], [_r, _g, _b, _veilAlpha], [_r, _g, _b, 0]], [1], 0, 0, "", "", objNull];
            };
        };
    };

    // Lightning arcs flashing on the surface in view.
    if (_scale >= 1 && _now >= _nextArc && _fadeStart < 0 && {_cfg getOrDefault ["domeLightning", true]}) then {
        _args set [3, _now + ([1 + random 2, 0.3 + random 1.2] select _high)];
        private _dir = _facing + random 100 - 50;
        private _pitch = _groundPitch + random ((70 - _groundPitch) max 0);
        private _point = _center vectorAdd [_sphere * cos _pitch * sin _dir, _sphere * cos _pitch * cos _dir, _sphere * sin _pitch];
        private _distance = _point distance _viewer;
        if ((_point select 2) > getTerrainHeightASL _point && _distance < EGVAR(main,maxViewDistance)) then {
            private _agl = ASLToAGL _point;
            private _bolt = (6 + random 10) * (1 + _distance / 500);
            for "_i" from 0 to (1 + floor random 3) do {
                drop [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.1 + random 0.25, _agl vectorAdd [random 6 - 3, random 6 - 3, random 6 - 3], [0, 0, 0], random 360, 1.275, 1, 0, [_bolt * (0.6 + random 0.4)],
                    [[0.6, 0.8, 1, 0.9], [0.5, 0.7, 1, 0.6], [0.5, 0.7, 1, 0]], [1], 0, 0, "", "", objNull, random 360];
            };
            if (_high && _distance < 500) then {
                private _flash = "#lightpoint" createVehicleLocal _agl;
                _flash setLightColor [0.5, 0.75, 1];
                _flash setLightAmbient [0.3, 0.5, 1];
                _flash setLightBrightness 3;
                _flash setLightDayLight true;
                [{deleteVehicle _this}, _flash, 0.12] call CBA_fnc_waitAndExecute;
            };
        };
    };
}, 0, [_entry, objNull, -1, 0, "", 0, -1, [], []]] call CBA_fnc_addPerFrameHandler;
