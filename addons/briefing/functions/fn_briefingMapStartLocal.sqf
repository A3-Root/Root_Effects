#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing map script by the 77th JSOC community
 * Client side live map feed for one briefing map board. Paints a procedural
 * UI texture onto the board once, creates the map control inside it once and
 * then refreshes the feed at the configured interval, but only while the
 * player is near the board. Ends itself and stops refreshing once the anchor
 * is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Marker the map centers on, "" for the board position <STRING>
 * 2: Map zoom, smaller is closer <NUMBER>
 * 3: Player distance at which the feed refreshes <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, "", 0.1, 50] call root_effects_briefing_fnc_briefingMapStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_centerMarker", "", [""]], ["_zoom", 0.1, [0]], ["_activationDistance", 50, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, marker, zoom, actDist, texturePainted, displayName, lastCenter]
private _state = [_anchor, _centerMarker, _zoom, _activationDistance, false, "", [0, 0, 0]];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_centerMarker", "_zoom", "_activationDistance", "_painted", "_displayName", "_lastCenter"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _board = _anchor getVariable [QGVAR(board), objNull];
    if (isNull _board) exitWith {};

    if (!_painted) then {
        // Unique feed name per board so several boards can coexist.
        _displayName = format [QGVAR(feed_%1), hashValue _board];
        _board setObjectTexture [0, format ["#(rgb,2048,2048,1)ui('RscDisplayEmpty','%1')", _displayName]];
        _args set [4, true];
        _args set [5, _displayName];
    };

    if ((player distance _board) > _activationDistance) exitWith {};

    private _display = findDisplay _displayName;
    if (isNull _display) exitWith {};

    private _center = getPosATL _board;
    if (_centerMarker isNotEqualTo "" && {getMarkerColor _centerMarker isNotEqualTo ""}) then {
        _center = getMarkerPos _centerMarker;
    };

    private _map = _display getVariable [QGVAR(mapControl), controlNull];
    if (isNull _map) then {
        _map = _display ctrlCreate ["RscMapControl", -1];
        _map ctrlMapSetPosition [0.1, 0.1, 0.8, 0.8];
        _display setVariable [QGVAR(mapControl), _map];
        _args set [6, [0, 0, 0]];
    };

    // Re-center only when the tracked position actually moved.
    if (_center distance2D _lastCenter > 10) then {
        _map ctrlMapAnimAdd [0, _zoom, _center];
        ctrlMapAnimCommit _map;
        _args set [6, _center];
    };

    displayUpdate _display;
}, GVAR(mapUpdateInterval), _state] call CBA_fnc_addPerFrameHandler;
