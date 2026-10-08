#include "..\script_component.hpp"

/*
 * Author: Root, based on a briefing table script by the 77th JSOC community
 * Client side diorama for one briefing table: clones the objects of the marker
 * area onto the table as scaled local simple objects and models the terrain as a
 * grid of textured cubes. This follows the original JSOC table script: every
 * ground cube is tilted to the averaged terrain normal under it and enlarged by
 * the tilt so neighbouring cubes always overlap (no gaps), and the whole
 * miniature is lifted by a height offset so it sits on top of the table. The
 * build runs in small batches over several frames so even a dense area never
 * causes a frame spike, and the object count is capped by the server setting. A
 * watcher mutes the ambient environment while the player studies the table and
 * deletes the miniature once the anchor is gone.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Table object the miniature is built on <OBJECT>
 * 2: Marker naming the source area <STRING>
 * 3: Terrain sampling resolution, cells per table side <NUMBER>
 * 4: Miniature scale multiplier <NUMBER>
 * 5: Model the terrain relief <BOOL>
 * 6: Height offset in meters added on top of the table <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, _table, "briefing_area", 20, 1, true, 0.4] call root_effects_briefing_fnc_briefingTableStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_table", objNull, [objNull]], ["_marker", "", [""]], ["_resolution", 20, [0]], ["_scale", 1, [0]], ["_useTerrain", true, [false]], ["_heightOffset", 0.4, [0]]];

if (!hasInterface) exitWith {};
DBG(FORMAT_1("briefingTableStartLocal called with %1",_this));
if (isNull _anchor || {isNull _table} || _marker isEqualTo "") exitWith {
    DBG("briefing table aborted: anchor, table or marker missing");
};
if (getMarkerColor _marker isEqualTo "") exitWith {
    DBG(FORMAT_1("briefing table aborted: marker %1 does not exist on this machine",_marker));
};

_resolution = (_resolution max 8) min 40;

// Table geometry (geometry LOD bounding box, as in the original script).
private _boundingBox = 2 boundingBoxReal _table;
private _boxMin = _boundingBox select 0;
private _boxMax = _boundingBox select 1;
private _tableWidth = abs ((_boxMax select 0) - (_boxMin select 0));
private _tableLength = abs ((_boxMax select 1) - (_boxMin select 1));
private _tableHeight = abs ((_boxMax select 2) - (_boxMin select 2));
private _tableDir = getDir _table;

// Source area geometry. The area is treated as a square of the larger marker side.
private _markerPos = getMarkerPos _marker;
private _markerDir = markerDir _marker;
private _markerSize = getMarkerSize _marker;
private _maxSize = ((_markerSize select 0) max (_markerSize select 1)) max 1;
// An icon marker (or a tiny area) would model a patch of a few meters, which
// fills the table with a single texture; such markers show 250 m around them.
if (!((markerShape _marker) in ["RECTANGLE", "ELLIPSE"]) || _maxSize < 20) then {
    DBG(FORMAT_3("briefing table marker %1 is %2 of size %3, using a 250 m area around it instead",_marker,markerShape _marker,_maxSize));
    _maxSize = 250;
};

private _tableSize = ((_tableWidth min _tableLength) / 2) * _scale * 0.9;
private _modelScale = _tableSize / _maxSize;

DBG(FORMAT_4("briefing table %1 at %2: bounding box %3, table size %4",typeOf _table,mapGridPosition _table,_boundingBox,_tableSize));
DBG(FORMAT_4("briefing table area %1 at %2, size %3, model scale %4",_marker,mapGridPosition _markerPos,_maxSize,_modelScale));

// Collect the area objects once, biggest first, capped by the setting.
private _searchRadius = sqrt (2 * _maxSize * _maxSize);
private _square = [_markerPos, _maxSize, _maxSize, _markerDir, true];
private _sourceObjects = (nearestTerrainObjects [_markerPos, [], _searchRadius, false, true]) inAreaArray _square;
_sourceObjects append ((_markerPos nearObjects ["Static", _searchRadius]) inAreaArray _square);
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

// Reference frame anchored at the area center, aligned with the marker, 1 m above ground.
private _frame = "Land_HelipadEmpty_F" createVehicleLocal _markerPos;
_frame enableSimulation false;
private _framePos = +_markerPos;
_framePos set [2, (0 max getTerrainHeightASL _markerPos) + 1];
_frame setPosASL _framePos;
_frame setDir _markerDir;

// Height offset so the lowest object sits on the table top.
private _zOffset = 0;
if (_useTerrain && {_sized isNotEqualTo []}) then {
    private _minHeight = 100000;
    {
        _minHeight = _minHeight min ((getPosASL (_x select 1)) select 2);
    } forEach _sized;
    _zOffset = ((getPosASL _frame) select 2) - _minHeight;
};
private _liftVector = [0, 0, _tableHeight / 2 + _zOffset * _modelScale + 0.05 + _heightOffset];

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

DBG(FORMAT_4("briefing table: %1 objects, %2 terrain cells, lift %3 (height offset %4)",count _sized,count _terrainCells,_liftVector,_heightOffset));

// Build the miniature in small batches per tick to avoid frame spikes.
// [anchor, table, frame, modelScale, liftVector, objectQueue, terrainQueue, clones, envMuted, tableSize, useTerrain, tableDir, markerDir]
private _state = [_anchor, _table, _frame, _modelScale, _liftVector, _sized, _terrainCells, [], false, _tableSize, _useTerrain, _tableDir, _markerDir];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_table", "_frame", "_modelScale", "_liftVector", "_objectQueue", "_terrainQueue", "_clones", "_envMuted", "_tableSize", "_useTerrain", "_tableDir", "_markerDir"];

    if (isNull _anchor || {isNull _table}) exitWith {
        {
            deleteVehicle _x;
        } forEach _clones;
        deleteVehicle _frame;
        if (_envMuted) then {
            enableEnvironment true;
        };
        DBG(FORMAT_1("briefing table removed (%1 pieces)",count _clones));
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
        if (_objectQueue isEqualTo []) then {
            DBG(FORMAT_1("briefing table objects placed (%1 pieces so far)",count _clones));
        };
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
            private _texture = [(getRoadInfo _road) param [3, ""], surfaceTexture _worldPos] select (isNull _road);
            // Some terrain and road textures do not exist as files or do not load on
            // a cube (procedural or missing paths); those tiles get a solid colour
            // from the ground type instead of rendering blank or broken.
            private _file = _texture;
            if ((_file select [0, 1]) == "\") then {_file = _file select [1]};
            if (_texture isEqualTo "" || {(_texture select [0, 1]) == "#"} || {!fileExists _file}) then {
                private _surface = toLowerANSI surfaceType _worldPos;
                private _rgb = switch (true) do {
                    case (!isNull _road): {"0.25,0.25,0.25"};
                    case ("grass" in _surface || {"forest" in _surface}): {"0.3,0.4,0.18"};
                    case ("sand" in _surface || {"beach" in _surface}): {"0.7,0.62,0.45"};
                    case ("rock" in _surface || {"stone" in _surface}): {"0.45,0.43,0.4"};
                    case ("concrete" in _surface || {"asphalt" in _surface}): {"0.35,0.35,0.35"};
                    default {"0.42,0.36,0.25"};
                };
                if ((count _clones) mod 50 == 0) then {
                    DBG(FORMAT_3("briefing tile texture '%1' unusable (surface %2), using colour %3",_texture,_surface,_rgb));
                };
                _texture = format ["#(rgb,8,8,3)color(%1,1)", _rgb];
                _args set [13, (_args param [13, 0]) + 1];
            };
            private _normal = vectorUp _table;
            private _cubeSize = _step * _tableSize;

            if (_useTerrain) then {
                // Average the terrain normal around the cell and tilt the cube to it;
                // a tilted cube is enlarged by the tilt so it still meets its
                // neighbours and no gaps open up between tiles.
                private _averageStep = _step / 2;
                for "_normalX" from -2 * _averageStep to 2 * _averageStep step _averageStep do {
                    for "_normalY" from -2 * _averageStep to 2 * _averageStep step _averageStep do {
                        _normal = _normal vectorAdd (surfaceNormal (_worldPos vectorAdd [_normalX, _normalY]));
                    };
                };
                _normal = [_normal, _tableDir - _markerDir, 2] call BIS_fnc_rotateVector3D;
                private _cos = (abs ((vectorUp _table) vectorCos _normal)) max 0.2;
                _cubeSize = _cubeSize * (1.1 / _cos);
                _cellPos set [2, -((_worldPos select 2) * _modelScale + _cubeSize / (2 * _cos) + 0.5)];
            } else {
                _cellPos set [2, -0.5 - _cubeSize / 2];
            };

            private _cube = createSimpleObject ["Land_VR_Shape_01_cube_1m_F", [0, 0, 0], true];
            _cube setPosASL (_table modelToWorldWorld (_cellPos vectorAdd _liftVector));
            _cube setVectorDirAndUp _dirAndUp;
            _cube setVectorUp _normal;
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
        if (_terrainQueue isEqualTo []) then {
            DBG(FORMAT_2("briefing table terrain laid (%1 pieces in total, %2 tiles with a fallback colour)",count _clones,_args param [ARR_2(13,0)]));
        };
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
