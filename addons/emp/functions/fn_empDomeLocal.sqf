#include "..\script_component.hpp"

/*
 * Author: Root
 * Client dome of an EMP field, growing with the shockwave to the field cap. On
 * shutdown it fades out (endMode 0) or shrinks with the wall running back in
 * (endMode 1):
 * - shell: local tinted glass sphere without collision, seen from outside and
 *   inside, built from 15 x 15 degree curved patches,
 * - veil: faint tinted glow drifting on the surface near the viewer,
 * - domeMirage: heat haze on the surface, densest where it meets the ground, and
 *   near the ground around a viewer inside,
 * - domeLightning: lightning arcs on the surface in view, and sparks and crackle
 *   around a viewer inside,
 * - high quality: denser veil and haze, shimmer, more arcs, spark flashes.
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

private _anchor = _entry param [0, objNull];
if (_anchor getVariable [QGVAR(domeLocal), false]) exitWith {
    DBG(FORMAT_1("EMP dome at %1 already drawn",mapGridPosition _anchor));
};
_anchor setVariable [QGVAR(domeLocal), true];

#define PATCH_CLASS "ROOT_EMP_DomePatch"
#define PATCH_STEP 15
#define PATCH_MATERIAL QPATHTOF(data\dome_glass.rvmat)
// Per band: bounding box center of the patch on the unit sphere [out, up].
#define PATCH_CENTERS [[0.978831, 0.12941], [0.912271, 0.37941], [0.783541, 0.603553], [0.601415, 0.786566], [0.378302, 0.915976], [0.12941, 0.982963]]
#define FADE_TIME 2

// [entry, patches, end start, next arc, texture, next veil, shell key, next area effect]
[{
    params ["_args", "_handle"];
    _args params ["_entry", "_patches", "_endStart", "_nextArc", "_texture", "_nextVeil", "_shellKey", "_nextArea"];
    _entry params ["_anchor", "_cfg", "", "_detTime"];

    private _fnc_clear = {
        {deleteVehicle (_x select 0)} forEach _patches;
        _patches resize 0;
        _args set [6, []];
    };

    if (isNull _anchor) exitWith {
        call _fnc_clear;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _now = CBA_missionTime;
    if (_now < _detTime) exitWith {};
    if !(_cfg get "dome") exitWith {call _fnc_clear};

    private _radius = _cfg get "radius";
    private _speed = _cfg get "shockSpeed";
    private _scale = if (_speed > 0) then {(((_now - _detTime) * _speed) / _radius) min 1} else {1};
    private _alpha = _cfg get "domeAlpha";
    private _fade = 1;
    private _ending = _anchor getVariable [QGVAR(ending), false];
    if (_ending) then {
        private _implode = (_cfg getOrDefault ["endMode", 0]) == 1;
        if (_endStart < 0) then {
            _endStart = _now;
            _args set [2, _now];
            if (_implode && {_cfg get "visuals"}) then {[_entry] call FUNC(empImplodeLocal)};
        };
        if (_implode) then {
            // Shrinks with the wall and brightens as it closes in.
            private _wall = _radius - (_now - (_anchor getVariable [QGVAR(endTime), _endStart])) * (_anchor getVariable [QGVAR(endSpeed), _radius / IMPLODE_TIME]);
            _scale = (_wall / _radius) max 0;
            _fade = parseNumber (_scale > 0);
            _alpha = _alpha * (1 + 2 * (1 - _scale)) * _fade;
        } else {
            _fade = (1 - (_now - _endStart) / FADE_TIME) max 0;
            _alpha = _alpha * _fade;
        };
    };

    ([_radius, _cfg get "altitude"] call FUNC(empCap)) params ["_sphere", "_offset"];
    private _fullSphere = _sphere;
    _sphere = (_sphere * _scale) max 0.01;
    _offset = _offset * _scale;
    private _center = (getPosASL _anchor) vectorAdd [0, 0, _offset];

    private _viewer = AGLToASL (positionCameraToWorld [0, 0, 0]);
    private _toViewer = (_viewer distance _center) - _sphere;
    if (_toViewer > EGVAR(main,maxViewDistance) || _fade <= 0) exitWith {call _fnc_clear};

    // Shell: a ring of patches per band from 1, 2 or 6 bands (domeDepth) below the
    // ground line up, bands below the equator mirrored; moved and scaled when the
    // cap or its object moves.
    private _groundPitch = asin ((((-_offset) / _sphere) max -1) min 1);
    private _lowest = ((floor (_groundPitch / PATCH_STEP)) - ([1, 2, 6] select (_cfg get "domeDepth"))) max (-90 / PATCH_STEP);
    if (_patches isEqualTo [] || {(_shellKey param [2, 99]) != _lowest}) then {
        call _fnc_clear;
        for "_band" from _lowest to (90 / PATCH_STEP - 1) do {
            // abs: a ground line at pitch -0 would format as band "-0".
            private _model = abs ([_band, -_band - 1] select (_band < 0));
            (PATCH_CENTERS select _model) params ["_out", "_up"];
            for "_i" from 0 to (360 / PATCH_STEP - 1) do {
                private _azimuth = PATCH_STEP * (_i + 0.5);
                private _patch = createSimpleObject [format ["%1%2", PATCH_CLASS, _model], _center, true];
                _patch setObjectMaterial [0, PATCH_MATERIAL];
                _patches pushBack [_patch, [sin _azimuth, cos _azimuth, 0], _out, [_up, -_up] select (_band < 0)];
            };
        };
        DBG(FORMAT_4("EMP dome at %1: bands %2 to 5, %3 patches, %4 failed",mapGridPosition _anchor,_lowest,count _patches,{isNull (_x select 0)} count _patches));
        _args set [4, ""];
        _texture = "";
        _shellKey = [];
    };
    private _key = [round (_sphere * 10), _center apply {round (_x * 10)}, _lowest];
    if (_key isNotEqualTo _shellKey) then {
        {
            _x params ["_patch", "_dir", "_out", "_up"];
            _patch setPosWorld (_center vectorAdd (_dir vectorMultiply (_out * _sphere)) vectorAdd [0, 0, _up * _sphere]);
            _patch setVectorDirAndUp [_dir, [0, 0, [1, -1] select (_up < 0)]];
            _patch setObjectScale _sphere;
        } forEach _patches;
        _args set [6, _key];
    };

    private _high = GVAR(domeQuality) == 2;
    private _shellAlpha = _alpha;
    if ((_cfg get "domeShimmer") && _high) then {
        _shellAlpha = _shellAlpha * (0.8 + 0.2 * sin (_now * 90));
    };
    (_cfg get "domeColor") params ["_r", "_g", "_b"];
    // Alpha in steps of 0.005 so the procedural texture changes rarely.
    private _newTexture = format ["#(argb,8,8,3)color(%1,%2,%3,%4,ca)", _r, _g, _b, (round (((_shellAlpha max 0) min 1) * 200)) / 200];
    if (_newTexture isNotEqualTo _texture) then {
        {(_x select 0) setObjectTexture [0, _newTexture]} forEach _patches;
        _args set [4, _newTexture];
    };

    // Direction the surface effects favour: the camera heading inside, the viewer outside.
    private _inside = _toViewer < 0;
    private _facing = if (_inside) then {
        private _look = (AGLToASL (positionCameraToWorld [0, 0, 1])) vectorDiff _viewer;
        (_look select 0) atan2 (_look select 1)
    } else {
        (getPosASL _anchor) getDir _viewer
    };
    private _budget = (EGVAR(main,particleBudget)) max 0.1;
    private _mirage = _cfg getOrDefault ["domeMirage", true];
    private _lightning = _cfg getOrDefault ["domeLightning", true];
    private _veilRange = (_fullSphere * 2.2) max 600;

    // Veil and haze on the surface within range of the viewer, sized by distance so
    // they read the same near and far; the haze crowds the ground line.
    if (_now >= _nextVeil && abs _toViewer < _veilRange) then {
        _args set [5, _now + 0.1];
        private _veilAlpha = ((_alpha * 0.6) min 0.15) max 0.02;
        for "_i" from 1 to ceil (([4, 10] select _high) * _budget) do {
            private _dir = [random 360, _facing + random 90 - 45] select (random 1 < 0.6);
            private _pitch = [_groundPitch + random (80 - _groundPitch), _groundPitch + random 8] select (random 1 < 0.5);
            private _point = _center vectorAdd [_sphere * cos _pitch * sin _dir, _sphere * cos _pitch * cos _dir, _sphere * sin _pitch];
            private _distance = _point distance _viewer;
            if ((_point select 2) > getTerrainHeightASL _point && _distance < _veilRange) then {
                private _size = (_distance * 0.06) max 2;
                private _agl = ASLToAGL _point;
                if (_mirage) then {
                    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 3, _agl, [0, 0, 0.2], 0, 1.275, 1, 0, [_size, _size * 1.2],
                        [[1, 1, 1, 0], [1, 1, 1, _fade], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
                };
                drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 3, _agl, [0, 0, 0.2], 0, 1.275, 1, 0, [_size, _size * 1.3],
                    [[_r, _g, _b, 0], [_r, _g, _b, _veilAlpha], [_r, _g, _b, 0]], [0.1], 0, 0, "", "", objNull];
            };
        };

        // Inside: heat haze near the ground around the viewer.
        if (_inside && _mirage && !_ending) then {
            for "_i" from 1 to ceil (([2, 5] select _high) * _budget) do {
                private _dir = _facing + random 140 - 70;
                private _dist = 10 + random 110;
                private _point = _viewer vectorAdd [_dist * sin _dir, _dist * cos _dir, 0];
                _point set [2, (getTerrainHeightASL _point) + 0.5 + random 2];
                if ([_point, _entry, false] call FUNC(empInZone)) then {
                    private _size = 3 + _dist * 0.05;
                    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2.5, ASLToAGL _point, [0, 0, 0.3], 0, 1.275, 1, 0, [_size, _size * 1.4],
                        [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", objNull];
                };
            };
        };
    };

    if (_scale < 1 || _ending || !_lightning) exitWith {};

    // Lightning arcs on the surface in view.
    if (_now >= _nextArc) then {
        _args set [3, _now + ([1 + random 2, 0.3 + random 1.2] select _high)];
        private _dir = _facing + random 100 - 50;
        private _pitch = _groundPitch + random ((70 - _groundPitch) max 0);
        private _point = _center vectorAdd [_sphere * cos _pitch * sin _dir, _sphere * cos _pitch * cos _dir, _sphere * sin _pitch];
        private _distance = _point distance _viewer;
        if ((_point select 2) > getTerrainHeightASL _point && _distance < EGVAR(main,maxViewDistance)) then {
            private _agl = ASLToAGL _point;
            [_agl, 0.1 + random 0.1, 0.15 * (1 + _distance / 500), 0.3, 0.04, 0.3] call FUNC(empBoltLocal);
        };
    };

    // Inside: sparks and crackle on the ground around the viewer.
    if (_inside && _now >= _nextArea) then {
        _args set [7, _now + ([6 + random 6, 3 + random 4] select _high)];
        private _dir = _facing + random 160 - 80;
        private _dist = 30 + random 120;
        private _point = _viewer vectorAdd [_dist * sin _dir, _dist * cos _dir, 0];
        _point set [2, getTerrainHeightASL _point];
        if !([_point, _entry, false] call FUNC(empInZone)) exitWith {};
        private _agl = ASLToAGL _point;
        for "_i" from 1 to ceil (([10, 20] select _high) * _budget) do {
            drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.4 + random 0.6, _agl vectorAdd [0, 0, 0.3], [random 8 - 4, random 8 - 4, 2 + random 5], 0, 3, 1, 0.1, [0.15, 0.05],
                [[0.7, 0.9, 1, 1], [0.4, 0.6, 1, 0]], [1], 0, 0, "", "", objNull];
        };
        playSound3D [format [QPATHTOEF(ambientsfx,sounds\spark_%1.ogg), 1 + floor random 7], objNull, false, _point, 3, 0.8 + random 0.4, 300, 0, true];
        if (_high) then {
            private _flash = "#lightpoint" createVehicleLocal (_agl vectorAdd [0, 0, 2]);
            _flash setLightColor [0.5, 0.75, 1];
            _flash setLightAmbient [0.3, 0.5, 1];
            _flash setLightBrightness 2;
            _flash setLightDayLight true;
            [{deleteVehicle _this}, _flash, 0.1] call CBA_fnc_waitAndExecute;
        };
    };
}, 0, [_entry, [], -1, 0, "", 0, [], 0]] call CBA_fnc_addPerFrameHandler;
