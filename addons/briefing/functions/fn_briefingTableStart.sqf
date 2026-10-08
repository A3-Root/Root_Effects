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
    ["_useTerrain", true, [false]],
    ["_heightOffset", 0.4, [0]],
    ["_spawnClass", "", [""]],
    ["_spawnPos", [], [[]]],
    ["_spawnDir", 0, [0]]
];

DBG(FORMAT_1("briefingTableStart called with %1",_this));

if (!isServer) exitWith {};
if (!(["briefingtable"] call EFUNC(main,isEffectEnabled))) exitWith {};
// Zeus placed the module on the ground: spawn the table it asked for.
private _spawned = objNull;
if (isNull _table && _spawnClass isNotEqualTo "" && {isClass (configFile >> "CfgVehicles" >> _spawnClass)}) then {
    _spawned = createVehicle [_spawnClass, _spawnPos, [], 0, "CAN_COLLIDE"];
    _spawned setDir _spawnDir;
    _spawned setPosATL _spawnPos;
    _spawned allowDamage false;
    {_x addCuratorEditableObjects [[_spawned], false]} forEach allCurators;
    _table = _spawned;
    DBG(FORMAT_3("briefing table spawned %1 at %2, dir %3",_spawnClass,mapGridPosition _spawnPos,_spawnDir));
};

if (isNull _table || _marker isEqualTo "") exitWith {
    DBG(FORMAT_2("briefing table start rejected: table %1, marker '%2'",_table,_marker));
};

_table enableSimulationGlobal false;

private _anchor = ["briefingtable", QGVAR(tableLocal), [_table, _marker, _resolution, _scale, _useTerrain, _heightOffset], getPosATL _table] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {
    deleteVehicle _spawned;
};
// A table spawned for the miniature goes away with it.
if (!isNull _spawned) then {
    private _attached = _anchor getVariable [QEGVAR(main,attachedObjects), []];
    _attached pushBack _spawned;
    _anchor setVariable [QEGVAR(main,attachedObjects), _attached];
};

DBG(FORMAT_1("briefing table started from marker %1",_marker));
