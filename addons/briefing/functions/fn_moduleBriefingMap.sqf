#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing map script by the 77th JSOC community
 * Zeus module entry point for the live briefing map. Opens the configuration
 * dialog on the curator's machine and asks the server to place a map board
 * with a live map feed at the module position once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_briefing_fnc_moduleBriefingMap
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
private _dir = getDir _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["briefingmap"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

private _classPresets = ["Land_MapBoard_F", "Land_PCSet_01_screen_F", "Land_TripodScreen_01_large_F", "Land_BriefingRoomScreen_01_F"];
private _classNames = ["Map Board", "PC Screen", "Tripod Screen", "Briefing Room Screen"];

[LLSTRING(ModuleMap), [
    ["COMBO", [LLSTRING(AttrMapClass), LLSTRING(AttrMapClassTooltip)], [_classPresets, _classNames, 0]],
    ["EDIT", [LLSTRING(AttrMapCustomClass), LLSTRING(AttrMapCustomClassTooltip)], [""]],
    ["EDIT", [LLSTRING(AttrMapMarker), LLSTRING(AttrMapMarkerTooltip)], [""]],
    ["TOOLBOX:YESNO", [LLSTRING(AttrMapPickCenter), LLSTRING(AttrMapPickCenterTooltip)], false],
    ["SLIDER", [LLSTRING(AttrMapZoom), LLSTRING(AttrMapZoomTooltip)], [0.02, 1, 0.1, 2]],
    ["SLIDER:RADIUS", [LLSTRING(AttrMapActDist), LLSTRING(AttrMapActDistTooltip)], [10, 500, 50, 0, _pos, [7, 120, 32, 1]]]
], {
    params ["_results", "_data"];
    _data params ["_pos", "_dir"];
    _results params ["_class", "_customClass", "_centerMarker", "_pickCenter", "_zoom", "_activationDistance"];

    // A typed custom class always wins over the preset dropdown.
    if (_customClass isNotEqualTo "") then {
        _class = _customClass;
    };

    // Either click the shown area on the map now, or fall back to the marker /
    // board position handled client side when no explicit centre is given.
    if (_pickCenter) then {
        [objNull, {
            params ["_success", "", "_posASL", "_cbArgs"];
            _cbArgs params ["_pos", "_dir", "_centerMarker", "_class", "_zoom", "_activationDistance"];
            private _center = if (_success) then {ASLToAGL _posASL} else {[]};
            [QGVAR(startMap), [_pos, _dir, _center, _centerMarker, _class, _zoom, _activationDistance]] call CBA_fnc_serverEvent;
            [LLSTRING(MapStarted)] call zen_common_fnc_showMessage;
        }, [_pos, _dir, _centerMarker, _class, _zoom, _activationDistance], LLSTRING(SelectMapCenter)] call zen_common_fnc_selectPosition;
    } else {
        [QGVAR(startMap), [_pos, _dir, [], _centerMarker, _class, _zoom, _activationDistance]] call CBA_fnc_serverEvent;
        [LLSTRING(MapStarted)] call zen_common_fnc_showMessage;
    };
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_pos, _dir], QGVAR(mapDialog)] call zen_dialog_fnc_create;
