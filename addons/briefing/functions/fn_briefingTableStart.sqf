#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing table script by the 77th JSOC community
 * Starts a briefing table diorama on the server: validates the request and
 * broadcasts the build order to all clients (JIP safe). Every client builds
 * its own local miniature, so even a fully decorated table costs no network
 * traffic at all.
 *
 * Arguments:
 * 0: Table object the miniature is built on <OBJECT>
 * 1: Marker naming the source area <STRING>
 * 2: Terrain sampling resolution, cells per table side <NUMBER>
 * 3: Miniature scale multiplier <NUMBER>
 * 4: Model the terrain relief <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_table, "briefing_area", 20, 1, true] call root_effects_briefing_fnc_briefingTableStart
 */

params [
    ["_table", objNull, [objNull]],
    ["_marker", "", [""]],
    ["_resolution", 20, [0]],
    ["_scale", 1, [0]],
    ["_useTerrain", true, [false]]
];

if (!isServer) exitWith {};
if (!(["briefingtable"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (isNull _table || {_marker isEqualTo ""}) exitWith {};

_table enableSimulationGlobal false;

private _anchor = ["briefingtable", QGVAR(tableLocal), [_table, _marker, _resolution, _scale, _useTerrain], getPosATL _table] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("briefing table started from marker %1",_marker));
