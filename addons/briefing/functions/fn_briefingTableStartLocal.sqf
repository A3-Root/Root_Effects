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
if (isNull _anchor || {isNull _table} || {_marker isEqualTo ""}) exitWith {};
if (getMarkerColor _marker isEqualTo "") exitWith {};

_resolution = (_resolution max 8) min 40;

// Table geometry.
private _boundingBox = 2 boundingBoxReal _table;
private _boxMin = _boundingBox select 0;
private _boxMax = _boundingBox select 1;
private _tableWidth = abs ((_boxMax select 0) - (_boxMin select 0));
private _tableLength = abs ((_boxMax select 1) - (_boxMin select 1));
private _tableHeight = abs ((_boxMax select 2) - (_boxMin select 2));

// Source area geometry.
private _markerPos = getMarkerPos _marker;
private _markerDir = markerDir _marker;
private _markerSize = getMarkerSize _marker;
private _areaSize = (_markerSize select 0) max (_markerSize select 1);

private _tableSize = ((_tableWidth min _tableLength) / 2) * _scale * 0.9;
private _modelScale = _tableSize / _areaSize;

// Collect the area objects once, biggest first, capped by the setting.
private _searchRadius = sqrt (2 * _areaSize * _areaSize);
private _sourceObjects = (nearestTerrainObjects [_markerPos, [], _searchRadius, false, true]) inAreaArray [_markerPos, _areaSize, _areaSize, _markerDir, true];
_sourceObjects append ((_markerPos nearObjects ["Static", _searchRadius]) inAreaArray [_markerPos, _areaSize, _areaSize, _markerDir, true]);
_sourceObjects = _sourceObjects arrayIntersect _sourceObjects;

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

// Reference frame anchored at the area center, aligned with the marker.
private _frame = "Land_HelipadEmpty_F" createVehicleLocal _markerPos;
_frame enableSimulation false;
private _framePos = +_markerPos;
_framePos set [2, (0 max getTerrainHeightASL _markerPos) + 1];
_frame setPosASL _framePos;
_frame setDir _markerDir;

// Height offset so the lowest sampled point sits on the table top.
private _zOffset = 0;
if (_useTerrain && {_sized isNotEqualTo []}) then {
    private _minHeight = 100000;
    {
        _minHeight = _minHeight min ((getPosASL (_x select 1)) select 2);
    } forEach _sized;
    _zOffset = ((getPosASL _frame) select 2) - _minHeight;
};
private _liftVector = [0, 0, _tableHeight / 2 + _zOffset * _modelScale + 0.05];

// Terrain grid cells to sample.
private _terrainCells = [];
if (_useTerrain) then {
    private _step = 2 / _resolution;
    for "_cellX" from -1 to 1 step _step do {
        for "_cellY" from -1 to 1 step _step do {
            _terrainCells pushBack [_cellX, _cellY, _step];
        };
    };
};

// Build the miniature in small batches per tick to avoid frame spikes.
// [anchor, table, frame, modelScale, liftVector, objectQueue, terrainQueue, clones, envMuted, tableSize]
private _state = [_anchor, _table, _frame, _modelScale, _liftVector, _sized, _terrainCells, [], false, _tableSize];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_table", "_frame", "_modelScale", "_liftVector", "_objectQueue", "_terrainQueue", "_clones", "_envMuted", "_tableSize"];

    if (isNull _anchor || {isNull _table}) exitWith {
        {
            deleteVehicle _x;
        } forEach _clones;
        deleteVehicle _frame;
        if (_envMuted) then {
            enableEnvironment true;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Clone a batch of area objects onto the table.
    if (_objectQueue isNotEqualTo []) exitWith {
        private _batch = _objectQueue select [0, 15 min count _objectQueue];
        _objectQueue deleteRange [0, count _batch];

        {
            _x params ["", "_source", "_model"];
            if (!isNull _source) then {
                private _relCentre = _frame worldToModel (ASLToAGL getPosWorld _source);
                private _relDir = _frame vectorWorldToModel (vectorDir _source);
                private _relUp = _frame vectorWorldToModel (vectorUp _source);

                private _clone = createSimpleObject [_model, [0, 0, 0], true];
                _clone setPosWorld (_table modelToWorldWorld ((_relCentre vectorMultiply _modelScale) vectorAdd _liftVector));
                _clone setVectorDirAndUp [_table vectorModelToWorld _relDir, _table vectorModelToWorld _relUp];
                _clone setObjectScale (_modelScale * getObjectScale _source);
                _clones pushBack _clone;
            };
        } forEach _batch;
    };

    // Then lay the terrain cube grid, batch by batch.
    if (_terrainQueue isNotEqualTo []) exitWith {
        private _batch = _terrainQueue select [0, 15 min count _terrainQueue];
        _terrainQueue deleteRange [0, count _batch];

        private _dirAndUp = [vectorDir _table, vectorUp _table];
        {
            _x params ["_cellX", "_cellY", "_step"];

            private _cellPos = [_cellX * _tableSize, _cellY * _tableSize, 0];
            private _worldPos = _frame modelToWorld (_cellPos vectorMultiply (1 / _modelScale));
            private _road = roadAt (_worldPos select [0, 2]);
            private _texture = if (isNull _road) then {surfaceTexture _worldPos} else {(getRoadInfo _road) select 3};
            private _cubeSize = _step * _tableSize;
            _cellPos set [2, -((_worldPos select 2) * _modelScale + _cubeSize / 2 + 0.5)];

            private _cube = createSimpleObject ["Land_VR_Shape_01_cube_1m_F", [0, 0, 0], true];
            _cube setPosASL (_table modelToWorldWorld (_cellPos vectorAdd _liftVector));
            _cube setVectorDirAndUp _dirAndUp;
            for "_selection" from 0 to 6 do {
                _cube setObjectMaterial [_selection, "\a3\data_f\default.rvmat"];
                if (surfaceIsWater _worldPos) then {
                    _cube setObjectTexture [_selection, "#(rgb,8,8,3)color(0.1,0.2,1,1)"];
                } else {
                    _cube setObjectTexture [_selection, _texture];
                };
            };
            _cube setObjectScale _cubeSize;
            _clones pushBack _cube;
        } forEach _batch;
    };

    // Build finished: keep watching and mute nature sounds at the table.
    private _atTable = (player distance _table) < (_tableSize + 15);
    if (_atTable && {!_envMuted}) then {
        enableEnvironment false;
        _args set [8, true];
    };
    if (!_atTable && _envMuted) then {
        enableEnvironment true;
        _args set [8, false];
    };
}, 0.1, _state] call CBA_fnc_addPerFrameHandler;
