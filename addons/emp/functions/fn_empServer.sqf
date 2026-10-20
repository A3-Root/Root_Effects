#include "..\script_component.hpp"

/*
 * Author: Root
 * Server control of one EMP field: map marker growing with the shockwave,
 * shrinking with the wall in an implode shutdown and following the object, Zeus
 * marker resize applied to the radius, shutdown when the linger time runs out or
 * the object is destroyed.
 *
 * Arguments:
 * 0: Field anchor <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor] call root_effects_emp_fnc_empServer
 */

params [["_anchor", objNull, [objNull]]];

if (!isServer || {isNull _anchor}) exitWith {};

GVAR(markerId) = (missionNamespace getVariable [QGVAR(markerId), 0]) + 1;
// ZEN lets Zeus edit area markers whose name holds "zen_area_markers".
private _marker = format ["zen_area_markers_root_emp_%1", GVAR(markerId)];

// [anchor, marker, label marker, last radius set]
[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_marker", "_label", "_lastSize"];

    if (isNull _anchor) exitWith {
        deleteMarker _marker;
        deleteMarker _label;
        _handle call CBA_fnc_removePerFrameHandler;
    };
    private _cfg = _anchor getVariable [QGVAR(cfgMap), createHashMap];
    if (_anchor getVariable [QGVAR(ending), false]) exitWith {
        private _wall = -1;
        if ((_cfg getOrDefault ["endMode", 0]) == 1) then {
            _wall = (_cfg get "radius") - (CBA_missionTime - (_anchor getVariable [QGVAR(endTime), 0])) * (_anchor getVariable [QGVAR(endSpeed), 1e9]);
        };
        if (_wall <= 0 || {markerShape _marker isEqualTo ""}) exitWith {
            deleteMarker _marker;
            deleteMarker _label;
        };
        _marker setMarkerPosLocal (getPosATL _anchor);
        _marker setMarkerSize [_wall, _wall];
    };

    private _detTime = _anchor getVariable [QGVAR(detTime), 0];
    private _object = _anchor getVariable [QGVAR(object), objNull];
    private _now = CBA_missionTime;

    if (_cfg getOrDefault ["endOnDestroyed", true] && {!isNull _object} && {!alive _object}) exitWith {
        [_anchor] call FUNC(disable);
    };
    if (_now < _detTime) exitWith {};

    private _radius = _cfg get "radius";
    private _speed = _cfg get "shockSpeed";
    private _waveEnd = _detTime + (if (_speed > 0) then {_radius / _speed} else {0});
    private _linger = _cfg get "linger";
    if (_linger >= 0 && {_now >= _waveEnd + (_cfg get "effectDelay") + _linger}) exitWith {
        [_anchor] call FUNC(disable);
    };

    private _mode = _cfg get "marker";
    if (_mode == 0) exitWith {
        deleteMarker _marker;
        deleteMarker _label;
    };

    private _pos = getPosATL _anchor;
    if (markerShape _marker isEqualTo "") then {
        createMarker [_marker, _pos];
        _marker setMarkerShapeLocal "ELLIPSE";
        _marker setMarkerBrushLocal "FDiagonal";
        _marker setMarkerColorLocal "ColorBlue";
        _marker setMarkerAlphaLocal 0.6;
        _marker setMarkerSize [1, 1];
        _args set [3, 1];
        _lastSize = 1;
    };
    if (_mode == 2 && {markerType _label isEqualTo ""}) then {
        createMarker [_label, _pos];
        _label setMarkerTypeLocal "mil_warning";
        _label setMarkerColorLocal "ColorBlue";
        _label setMarkerText "EMP";
    };
    if (_mode == 1) then {deleteMarker _label};

    if ((markerPos _marker) distance2D _pos > 1) then {_marker setMarkerPos _pos};
    if ((markerPos _label) distance2D _pos > 1) then {_label setMarkerPos _pos};

    private _front = if (_now < _waveEnd) then {(_now - _detTime) * _speed} else {_radius};
    private _size = markerSize _marker;
    private _current = (_size select 0) max (_size select 1);

    // Zeus resized the marker after the wave: that becomes the radius.
    if (_now >= _waveEnd && {_cfg get "markerSync"} && {abs (_current - _lastSize) > 0.5} && {abs (_current - _radius) > 0.5}) exitWith {
        [_anchor, [["radius", _current]]] call FUNC(modify);
        _marker setMarkerSize [_current, _current];
        _args set [3, _current];
        DBG(FORMAT_2("EMP field at %1 resized by marker to %2",mapGridPosition _anchor,_current));
    };

    if (abs (_front - _lastSize) > 0.5) then {
        _marker setMarkerSize [_front, _front];
        _args set [3, _front];
    };
}, 0.25, [_anchor, _marker, _marker + "_label", 0]] call CBA_fnc_addPerFrameHandler;
