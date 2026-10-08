#include "..\script_component.hpp"

/*
 * Author: Root
 * Real physics debris for a scree avalanche, run on the server.
 *
 * Boulders: each boulder is an engine physics prop (PhysX "thingX" barrel, made
 * invisible but still solid) that is pushed downhill and spun, so it bounces off
 * the terrain, rolls, knocks into vehicles and people and comes to rest on its
 * own. Every client draws a rock model that follows its prop every frame
 * (avalancheLocal), because a simple object cannot be attached to a physics prop.
 *
 * Custom objects: classes named in the module roll down the same way. A class
 * that already has physics (props, vehicles) is spawned and shoved directly; a
 * static class (e.g. a timber log) rides an invisible physics prop the same way
 * a boulder does, so it still tumbles down instead of standing still.
 *
 * Damage, when lethal: everything in the moving front of the slide is crushed and
 * shoved downhill, and every fast boulder hurts what it hits. Vehicles take
 * hitpoint and hull damage and their crews are hurt. Infantry damage is raised for
 * ACE, whose wounds need far more than vanilla's 0..1.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Travel heading in degrees <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Boulder count <NUMBER>
 * 5: Custom object classes <ARRAY of STRING>
 * 6: Crush what the slide hits <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 120, 200, 25, 40, ["Land_TimberLog_04_F"], true] call root_effects_volcano_fnc_avalancheRocks
 */

params [
    ["_anchor", objNull, [objNull]],
    ["_heading", 0, [0]],
    ["_length", 200, [0]],
    ["_duration", 25, [0]],
    ["_count", 40, [0]],
    ["_classes", [], [[]]],
    ["_lethal", true, [false]]
];

DBG(FORMAT_1("avalancheRocks called with %1",_this));

if (!isServer || {isNull _anchor}) exitWith {};

_count = round ((_count max 0) min 80);

// First engine physics prop available; barrels roll and tumble nicely.
private _carrierClass = ["Land_BarrelEmpty_F", "Land_BarrelSand_F", "Land_GarbageBarrel_01_F", "Land_Tyre_F"] select {
    (toLowerANSI getText (configFile >> "CfgVehicles" >> _x >> "simulation")) isEqualTo "thingx"
} param [0, ""];

private _physics = ["thingx", "carx", "tankx", "shipx", "helicopterrtd", "helicopterx", "airplanex", "motorcycle", "soldier"];
private _rockModels = [
    "\a3\rocks_f\Blunt\BluntStone_01.p3d",
    "\a3\rocks_f\Blunt\BluntStone_02.p3d",
    "\a3\rocks_f\Sharp\sharpStone_01.p3d",
    "\a3\rocks_f\Sharp\sharpStone_02.p3d"
];

// What to release: [kind, class or model, scale]. kind 0 boulder, 1 carried model, 2 own physics.
private _queue = [];
for "_i" from 1 to _count do {
    _queue pushBack [0, selectRandom _rockModels, 0.3 + random 0.18];
};
{
    private _class = _x;
    private _sim = toLowerANSI getText (configFile >> "CfgVehicles" >> _class >> "simulation");
    private _model = getText (configFile >> "CfgVehicles" >> _class >> "model");
    private _kind = [1, 2] select (_sim in _physics);
    for "_i" from 1 to 4 do {
        _queue pushBack [_kind, [_model, _class] select (_kind == 2), 1];
    };
    private _how = ["rides a physics carrier", "has its own physics"] select (_kind == 2);
    DBG(FORMAT_3("avalanche custom object %1: simulation %2, %3",_class,_sim,_how));
} forEach _classes;
_queue = _queue call BIS_fnc_arrayShuffle;

if (_carrierClass isEqualTo "" && {_queue findIf {(_x select 0) != 2} != -1}) then {
    DBG("avalanche: no physics carrier class found, boulders and static objects skipped");
    _queue = _queue select {(_x select 0) == 2};
};

private _carriers = [];
_anchor setVariable [QGVAR(avalancheCarriers), _carriers, true];
private _attached = _anchor getVariable [QEGVAR(main,attachedObjects), []];
_anchor setVariable [QEGVAR(main,attachedObjects), _attached];

private _speed = (_length / _duration) max 5;
private _interval = (((_duration * 0.6) / ((count _queue) max 1)) max 0.15) min 2;
DBG(FORMAT_4("avalanche releasing %1 pieces (%2 boulders) every %3 s, carrier %4",count _queue,_count,_interval,_carrierClass));

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_heading", "_speed", "_carrierClass", "_queue", "_carriers", "_attached"];

    if (isNull _anchor || {_queue isEqualTo []}) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    (_queue deleteAt 0) params ["_kind", "_what", "_scale"];
    private _spawnPos = (getPosATL _anchor) getPos [2 + random 10, _heading + (random 70 - 35)];
    _spawnPos set [2, 1.5 + random 2];

    private _object = objNull;
    if (_kind == 2) then {
        _object = createVehicle [_what, _spawnPos, [], 0, "CAN_COLLIDE"];
        _object setPosATL _spawnPos;
    } else {
        _object = createVehicle [_carrierClass, _spawnPos, [], 0, "CAN_COLLIDE"];
        _object setPosATL _spawnPos;
        // Invisible but still solid: hiding an object would also take its collision away.
        {
            _object setObjectTextureGlobal [_forEachIndex, "#(argb,8,8,3)color(0,0,0,0)"];
        } forEach (getObjectTextures _object);
        _object setMass (1500 * _scale);
        // Clients read these to draw the rock (or carried model) on top.
        _object setVariable [QGVAR(rockModel), _what, true];
        _object setVariable [QGVAR(rockScale), _scale, true];
        _carriers pushBack _object;
        _anchor setVariable [QGVAR(avalancheCarriers), _carriers, true];
    };
    _object setDir random 360;

    private _launch = _speed * (0.8 + random 0.6);
    _object setVelocity [sin _heading * _launch, cos _heading * _launch, 2 + random 3];
    _object addTorque [random 6000 - 3000, random 6000 - 3000, random 2000 - 1000];
    _object setVariable [QGVAR(rockBorn), CBA_missionTime];
    _attached pushBack _object;
}, _interval, [_anchor, _heading, _speed, _carrierClass, _queue, _carriers, _attached]] call CBA_fnc_addPerFrameHandler;

if (!_lethal) exitWith {
    DBG("avalanche is not lethal, no damage");
};

// Damage: the moving front of the slide, and every fast boulder or object.
[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_heading", "_length", "_duration", "_startTime", "_lastHit", "_attached", "_hits"];

    if (isNull _anchor) exitWith {
        DBG(FORMAT_1("avalanche damage ended, %1 hits dealt",_hits));
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _ace = EGVAR(main,aceMedicalLoaded);
    private _fnc_hit = {
        params ["_target", "_impact", "_push", "_why"];
        private _netId = netId _target;
        if (_target isKindOf "VirtualMan_F" || {CBA_missionTime < (_lastHit getOrDefault [_netId, -10]) + 1}) exitWith {};
        _lastHit set [_netId, CBA_missionTime];
        if (_target isKindOf "CAManBase") then {
            if (isNull objectParent _target) then {
                [_target, [_impact, _impact * 4] select _ace, selectRandom ["Body", "LeftLeg", "RightLeg", "Head"], "falling", _anchor] call EFUNC(main,doDamage);
                [QGVAR(avalanchePush), [_target, _push], _target] call CBA_fnc_targetEvent;
            };
        } else {
            [_target, _impact * 0.6, true] call EFUNC(main,doHitPointDamage);
            [_target, _impact * 0.35, "Body", "explosive", _anchor] call EFUNC(main,doDamage);
            [QGVAR(avalanchePush), [_target, _push vectorMultiply 0.6], _target] call CBA_fnc_targetEvent;
            {
                [_x, [_impact * 0.3, _impact * 1.2] select _ace, selectRandom ["Body", "LeftLeg", "RightLeg"], "falling", _anchor] call EFUNC(main,doDamage);
            } forEach (crew _target);
        };
        _args set [7, (_args select 7) + 1];
        DBG(FORMAT_4("avalanche %1 hit %2 for %3 at %4",_why,typeOf _target,_impact,mapGridPosition _target));
    };

    // The front: a band trailing the head of the slide, as wide as the debris.
    private _progress = (CBA_missionTime - _startTime) / _duration;
    if (_progress <= 1) then {
        private _head = getPosATL _anchor;
        private _frontDist = _length * _progress;
        private _frontSpeed = _length / _duration;
        private _push = [sin _heading * _frontSpeed * 0.6, cos _heading * _frontSpeed * 0.6, 1 + random 2];
        {
            private _rel = (getPosATL _x) vectorDiff _head;
            private _along = (_rel select 0) * sin _heading + (_rel select 1) * cos _heading;
            private _across = abs ((_rel select 0) * cos _heading - (_rel select 1) * sin _heading);
            if (_along > _frontDist - 35 && {_along < _frontDist + 5} && _across < 22) then {
                [_x, 0.35 + random 0.3, _push, "front"] call _fnc_hit;
            };
        } forEach ((_head getPos [(_frontDist - 15) max 0, _heading]) nearEntities [["Man", "LandVehicle", "Ship", "StaticWeapon"], 45]);
    };

    // Moving boulders and objects.
    {
        private _piece = _x;
        if (!isNull _piece) then {
            private _velocity = velocity _piece;
            private _speed = vectorMagnitude _velocity;
            if (_speed > 3) then {
                private _scale = _piece getVariable [QGVAR(rockScale), 1];
                private _impact = ((_speed / 15) min 1) * (0.5 + _scale);
                private _push = (vectorNormalized _velocity) vectorMultiply (_speed * 0.5);
                _push set [2, 1 + random 2];
                {
                    if (_x != _piece) then {[_x, _impact, _push, "boulder"] call _fnc_hit};
                } forEach ((getPosATL _piece) nearEntities [["Man", "LandVehicle", "Ship", "StaticWeapon"], 2 + _scale * 2]);
            };
            // Settled pieces are cleared after a while so the slope does not fill up.
            if (_speed < 0.3 && {CBA_missionTime - (_piece getVariable [QGVAR(rockBorn), CBA_missionTime]) > 20}) then {
                deleteVehicle _piece;
            };
        };
    } forEach _attached;
}, 0.2, [_anchor, _heading, _length, _duration, CBA_missionTime, createHashMap, _attached, 0]] call CBA_fnc_addPerFrameHandler;
