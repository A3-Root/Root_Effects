#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing table script by the 77th JSOC community
 * Client side diorama for one briefing table: clones the objects of the
 * marker area onto the table as scaled local simple objects and models the
 * terrain as a grid of textured cubes. The build runs in small batches over
 * several frames so even a dense area never causes a frame spike, and the
 * object count is capped by the server setting. A watcher loop mutes the
 * ambient environment while the player studies the table and deletes the
 * miniature once the anchor is gone.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Table object the miniature is built on <OBJECT>
 * 2: Marker naming the source area <STRING>
 * 3: Terrain sampling resolution, cells per table side <NUMBER>
 * 4: Miniature scale multiplier <NUMBER>
 * 5: Model the terrain relief <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, _table, "briefing_area", 20, 1, true] call root_effects_briefing_fnc_briefingTableStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_table", objNull, [objNull]], ["_marker", "", [""]], ["_resolution", 20, [0]], ["_scale", 1, [0]], ["_useTerrain", true, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor || {isNull _table} || _marker isEqualTo "") exitWith {};
DBG(FORMAT_1("briefingTableStartLocal running here with %1",_this));
if (getMarkerColor _marker isEqualTo "") exitWith {};

_resolution = (_resolution max 8) min 40;

DBG(FORMAT_4("briefing table building from %1 (res %2, scale %3, terrain %4)",_marker,_resolution,_scale,_useTerrain));

// Table geometry in model space. The miniature sits on the real top surface of the
// model (bounding box top), centred on the bounding box, not on the model origin.
private _boundingBox = 0 boundingBoxReal _table;
_boundingBox params ["_boxMin", "_boxMax"];
private _tableWidth = abs ((_boxMax select 0) - (_boxMin select 0));
private _tableLength = abs ((_boxMax select 1) - (_boxMin select 1));
private _topZ = (_boxMax select 2) + 0.01;
private _centreX = ((_boxMin select 0) + (_boxMax select 0)) / 2;
private _centreY = ((_boxMin select 1) + (_boxMax select 1)) / 2;

// Source area geometry. Area offsets are taken in the marker's own frame, so a
// rotated marker still lays out along the table.
private _markerPos = getMarkerPos _marker;
_markerPos set [2, 0];
private _markerDir = markerDir _marker;
private _markerSize = getMarkerSize _marker;
private _areaSize = ((_markerSize select 0) max (_markerSize select 1)) max 1;
private _isArea = (markerShape _marker) in ["RECTANGLE", "ELLIPSE"];
private _right = [cos _markerDir, -sin _markerDir, 0];
private _forward = [sin _markerDir, cos _markerDir, 0];

private _tableSize = ((_tableWidth min _tableLength) / 2) * _scale * 0.9;
private _modelScale = _tableSize / _areaSize;

// World position (z 0) of a point given in area units -1..1.
private _fnc_areaToWorld = {
    params ["_u", "_v"];
    _markerPos vectorAdd (_right vectorMultiply (_u * _areaSize)) vectorAdd (_forward vectorMultiply (_v * _areaSize))
};
// Table model position for a world position, at a height above the table top.
private _fnc_worldToTable = {
    params ["_worldPos", "_height"];
    private _offset = _worldPos vectorDiff _markerPos;
    [
        _centreX + (_offset vectorDotProduct _right) * _modelScale,
        _centreY + (_offset vectorDotProduct _forward) * _modelScale,
        _topZ + _height
    ]
};

// Terrain grid cells, sampled once. Cells outside an ellipse/rectangle marker are
// skipped so the miniature follows the marker shape with no stray tiles.
private _cells = [];
private _baseHeight = 1e6;
if (_useTerrain) then {
    private _step = 2 / _resolution;
    for "_cellU" from (-1 + _step / 2) to 1 step _step do {
        for "_cellV" from (-1 + _step / 2) to 1 step _step do {
            private _worldPos = [_cellU, _cellV] call _fnc_areaToWorld;
            if (!_isArea || {_worldPos inArea _marker}) then {
                private _height = 0 max getTerrainHeightASL _worldPos;
                _baseHeight = _baseHeight min _height;
                _cells pushBack [_worldPos, _height, _step];
            };
        };
    };
};
if (_baseHeight > 1e5) then {_baseHeight = 0 max getTerrainHeightASL _markerPos};

// Collect the area objects once, biggest first, capped by the setting.
private _searchRadius = _areaSize * sqrt 2;
private _sourceObjects = (nearestTerrainObjects [_markerPos, [], _searchRadius, false, true]) inAreaArray [_markerPos, _areaSize, _areaSize, _markerDir, true];
_sourceObjects append ((_markerPos nearObjects ["Static", _searchRadius]) inAreaArray [_markerPos, _areaSize, _areaSize, _markerDir, true]);
_sourceObjects = _sourceObjects arrayIntersect _sourceObjects;
if (_isArea) then {_sourceObjects = _sourceObjects inAreaArray _marker};

private _sized = [];
{
    private _model = (getModelInfo _x) select 1;
    if (_model isNotEqualTo "" && {!isObjectHidden _x}) then {
        private _height = ((boundingBoxReal _x) select 2) * _modelScale * getObjectScale _x;
        if (_height > 0.005) then {
            _sized pushBack [_height, _x, _model];
        };
    };
} forEach _sourceObjects;
_sized sort false;
_sized resize ((count _sized) min (floor GVAR(maxTableObjects)));

DBG(FORMAT_3("briefing table: %1 terrain cells, %2 objects, scale %3",count _cells,count _sized,_modelScale));

// Build the miniature in small batches per tick to avoid frame spikes.
// [anchor, table, objectQueue, terrainQueue, clones, envMuted, tableSize, settings]
private _settings = [_modelScale, _baseHeight, _useTerrain, _markerDir, _fnc_worldToTable, _markerPos, _right, _forward, _centreX, _centreY, _topZ];
private _state = [_anchor, _table, _sized, _cells, [], false, _tableSize, _settings];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_table", "_objectQueue", "_terrainQueue", "_clones", "_envMuted", "_tableSize", "_settings"];
    // The position helper reads these by name, so they are unpacked here too.
    _settings params ["_modelScale", "_baseHeight", "_useTerrain", "_markerDir", "_fnc_worldToTable", "_markerPos", "_right", "_forward", "_centreX", "_centreY", "_topZ"];

    if (isNull _anchor || {isNull _table}) exitWith {
        {
            deleteVehicle _x;
        } forEach _clones;
        if (_envMuted) then {
            enableEnvironment true;
        };
        DBG("briefing table removed");
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Lay the terrain tiles first, so objects visibly land on top of them.
    if (_terrainQueue isNotEqualTo []) exitWith {
        private _batch = _terrainQueue select [0, 20 min count _terrainQueue];
        _terrainQueue deleteRange [0, count _batch];

        private _dirAndUp = [vectorDir _table, vectorUp _table];
        {
            _x params ["_worldPos", "_height", "_step"];

            private _cubeSize = _step * _tableSize;
            private _relief = (_height - _baseHeight) * _modelScale;
            // Cube top flush with the relief; the body sinks into the table.
            private _modelPos = [_worldPos, _relief - _cubeSize / 2] call _fnc_worldToTable;

            private _texture = "";
            private _water = surfaceIsWater _worldPos;
            private _road = roadAt _worldPos;
            if (!_water) then {
                _texture = [(getRoadInfo _road) param [3, ""], surfaceTexture _worldPos] select (isNull _road);
            };
            if (_texture isEqualTo "") then {
                // Fall back to a flat colour from the ground type so no tile is blank.
                private _surface = toLowerANSI surfaceType _worldPos;
                private _rgb = switch (true) do {
                    case (_water): {"0.1,0.25,0.6"};
                    case (!isNull _road): {"0.25,0.25,0.25"};
                    case ("grass" in _surface || {"forest" in _surface}): {"0.3,0.4,0.18"};
                    case ("sand" in _surface || {"beach" in _surface}): {"0.7,0.62,0.45"};
                    case ("rock" in _surface || {"stone" in _surface}): {"0.45,0.43,0.4"};
                    case ("concrete" in _surface || {"asphalt" in _surface}): {"0.35,0.35,0.35"};
                    default {"0.42,0.36,0.25"};
                };
                _texture = format ["#(rgb,8,8,3)color(%1,1)", _rgb];
            };

            private _cube = createSimpleObject ["Land_VR_Shape_01_cube_1m_F", [0, 0, 0], true];
            _cube setPosWorld (_table modelToWorldWorld _modelPos);
            _cube setVectorDirAndUp _dirAndUp;
            for "_selection" from 0 to 6 do {
                _cube setObjectMaterial [_selection, "\a3\data_f\default.rvmat"];
                _cube setObjectTexture [_selection, _texture];
            };
            _cube setObjectScale _cubeSize;
            _clones pushBack _cube;
        } forEach _batch;
    };

    // Then clone the area objects onto the relief, batch by batch.
    if (_objectQueue isNotEqualTo []) exitWith {
        private _batch = _objectQueue select [0, 15 min count _objectQueue];
        _objectQueue deleteRange [0, count _batch];

        {
            _x params ["", "_source", "_model"];
            if (!isNull _source) then {
                // Height of the object's centre above the miniature's base level:
                // over the relief with terrain on, over a flat table top without it.
                private _centre = getPosWorld _source;
                private _ground = [0 max getTerrainHeightASL _centre, _baseHeight] select _useTerrain;
                private _modelPos = [_centre, ((_centre select 2) - _ground) * _modelScale] call _fnc_worldToTable;

                private _clone = createSimpleObject [_model, [0, 0, 0], true];
                _clone setPosWorld (_table modelToWorldWorld _modelPos);
                _clone setDir ((getDir _table) + (getDir _source) - _markerDir);
                _clone setVectorUp (vectorUp _table);
                _clone setObjectScale (_modelScale * getObjectScale _source);
                _clones pushBack _clone;
            };
        } forEach _batch;
    };

    // Build finished: keep watching and mute nature sounds at the table.
    private _atTable = (player distance _table) < (_tableSize + 15);
    if (_atTable && {!_envMuted}) then {
        enableEnvironment false;
        _args set [5, true];
    };
    if (!_atTable && _envMuted) then {
        enableEnvironment true;
        _args set [5, false];
    };
}, 0.1, _state] call CBA_fnc_addPerFrameHandler;
