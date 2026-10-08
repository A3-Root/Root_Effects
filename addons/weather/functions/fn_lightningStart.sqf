#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts a lightning storm on the server: real engine lightning bolts strike
 * random points inside the area at randomized intervals. The engine renders
 * bolt, flash and thunder for every client on its own, so the storm needs no
 * client side code at all. Optionally damages units next to a strike.
 *
 * Arguments:
 * 0: Position ATL of the storm center <ARRAY>
 * 1: Storm radius in meters <NUMBER>
 * 2: Storm duration in seconds, 0 for endless <NUMBER>
 * 3: Minimum seconds between strikes <NUMBER>
 * 4: Maximum seconds between strikes <NUMBER>
 * 5: Strikes damage nearby units <BOOL>
 * 6: Pull a storm sky over the mission for the duration <BOOL>
 * 7: Storm strength 0..1, scales weather, strike rate and bolt light <NUMBER>
 * 8: Spawn a tornado <BOOL>
 * 9: Tornado width in meters <NUMBER>
 * 10: Tornado travel speed in m/s <NUMBER>
 * 11: Tornado throws and damages what it passes <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 300, 300, 5, 20, false, true] call root_effects_weather_fnc_lightningStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 300, [0]],
    ["_duration", 300, [0]],
    ["_minInterval", 5, [0]],
    ["_maxInterval", 20, [0]],
    ["_damage", false, [false]],
    ["_ambience", true, [false]],
    ["_strength", 0.7, [0]],
    ["_tornado", false, [false]],
    ["_tornadoSize", 120, [0]],
    ["_tornadoSpeed", 8, [0]],
    ["_tornadoFling", false, [false]]
];

DBG(FORMAT_1("lightningStart called with %1",_this));

if (!isServer) exitWith {};
if (!(["lightningstorm"] call EFUNC(main,isEffectEnabled))) exitWith {};

_minInterval = _minInterval max 1;
_maxInterval = _maxInterval max _minInterval;
_damage = _damage && GVAR(allowDamage);
_strength = (_strength max 0) min 1;

// Stronger storms strike more often.
private _rateScale = 0.5 + _strength;
_minInterval = (_minInterval / _rateScale) max 0.5;
_maxInterval = (_maxInterval / _rateScale) max _minInterval;

private _anchor = ["lightningstorm", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// A clear blue sky undercuts the storm, so cloud, rain, fog and ambient
// lightning are pulled in for as long as it runs and eased back afterwards.
private _prevWeather = [overcast, rain, fogParams, lightnings];
if (_ambience) then {
    0 setOvercast (0.75 + 0.25 * _strength);
    0 setLightnings (0.3 + 0.7 * _strength);
    forceWeatherChange;
    // Rain only falls under heavy cloud, so it is set once the overcast took.
    [{
        params ["_strength"];
        30 setRain (0.3 + 0.7 * _strength);
        30 setFog [0.08 + 0.3 * _strength, 0.015, 0];
    }, [_strength], 1] call CBA_fnc_waitAndExecute;
};

// Optional tornado wandering through the storm. Its path is seeded and computed
// from mission time on every machine, so only the seed is broadcast.
if (_tornado) then {
    _tornadoSize = (_tornadoSize max 50) min 300;
    _tornadoSpeed = (_tornadoSpeed max 1) min 40;
    private _seed = floor random 1e6;
    private _center = getPosATL _anchor;
    [QGVAR(tornadoLocal), [_anchor, _radius, _tornadoSize, _tornadoSpeed, _seed], _anchor] call CBA_fnc_globalEventJIP;
    DBG(FORMAT_4("tornado spawned, width %1, speed %2, throws %3, seed %4",_tornadoSize,_tornadoSpeed,_tornadoFling,_seed));

    // The tornado's wind runs for as long as it exists. Inside its wall everything
    // is shoved away from the funnel and slowed down, and keeps taking damage
    // that builds up to destruction: people, vehicles, buildings, walls, trees.
    // With "throws objects" on, whatever gets near the core is also sucked in,
    // spun and lifted.
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_center", "_radius", "_size", "_speed", "_seed", "_fling", "_tick"];
        if (isNull _anchor) exitWith {_handle call CBA_fnc_removePerFrameHandler};

        _args set [7, _tick + 1];
        private _pos = [_center, _radius, _speed, _seed] call FUNC(tornadoPos);
        private _wall = _size * 0.5;
        private _core = _size * 0.15;
        private _damage = EGVAR(main,damageAllowed) && GVAR(allowDamage);
        private _ace = EGVAR(main,aceMedicalLoaded);
        private _hitUnits = 0;

        {
            private _target = _x;
            if (!(_target isKindOf "VirtualMan_F") && {isNull attachedTo _target}) then {
                private _offset = (getPosATL _target) vectorDiff _pos;
                private _distance = vectorMagnitude [_offset select 0, _offset select 1, 0];
                private _power = linearConversion [0, _wall, _distance, 1, 0.2, true];
                private _outward = vectorNormalized [_offset select 0, _offset select 1, 0];
                private _tangent = [-(_outward select 1), _outward select 0, 0];
                private _massScale = linearConversion [500, 40000, getMass _target, 1, 0.3, true];

                private _push = [];
                private _damping = 1;
                if (_fling && _distance < _core) then {
                    // Core: drawn in, spun hard and lifted.
                    _push = (_tangent vectorMultiply 16) vectorDiff (_outward vectorMultiply 4) vectorAdd [0, 0, 12];
                } else {
                    // Wall: blown away from the funnel and around it, and held back.
                    _push = (_outward vectorMultiply (9 * _power)) vectorAdd (_tangent vectorMultiply (6 * _power)) vectorAdd [0, 0, 1.5 * _power];
                    _damping = 1 - 0.5 * _power;
                };
                [QGVAR(tornadoWind), [_target, _push vectorMultiply _massScale, _damping], _target] call CBA_fnc_targetEvent;

                if (_damage) then {
                    private _amount = 0.02 + 0.06 * _power;
                    if (_target isKindOf "CAManBase") then {
                        [_target, [_amount, _amount * 4] select _ace, selectRandom ["Body", "Head", "LeftLeg", "RightLeg", "LeftArm", "RightArm"], "falling", _anchor] call EFUNC(main,doDamage);
                    } else {
                        if (_target isKindOf "AllVehicles") then {
                            [_target, _amount, true] call EFUNC(main,doHitPointDamage);
                            [_target, _amount * 0.5, "Body", "falling", _anchor] call EFUNC(main,doDamage);
                        };
                    };
                    _hitUnits = _hitUnits + 1;
                };
            };
        } forEach (nearestObjects [_pos, ["CAManBase", "LandVehicle", "Ship", "StaticWeapon", "Air", "ThingX", "ReammoBox_F"], _wall]);

        // Structures, walls and vegetation weather towards collapse, once a second.
        private _structures = 0;
        if (_damage && {_tick mod 2 == 0}) then {
            private _objects = nearestTerrainObjects [_pos, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "TRANSMITTER", "LIGHTHOUSE", "WATERTOWER", "POWER LINES", "TREE", "SMALL TREE", "BUSH", "WALL", "FENCE", "HIDE"], _wall, false, true];
            _objects append (nearestObjects [_pos, ["Building", "House", "Wall"], _wall, true]);
            _objects = (_objects arrayIntersect _objects) select {alive _x && {damage _x < 1}};
            {
                private _power = linearConversion [0, _wall, _x distance2D _pos, 1, 0.3, true];
                _x setDamage (((damage _x) + 0.06 * _power + 0.02) min 1);
            } forEach (_objects select [0, 250]);
            _structures = count _objects;
        };

        if (_tick mod 20 == 0) then {
            DBG(FORMAT_4("tornado at %1: %2 objects in its wind, %3 structures weathering, damage %4",mapGridPosition _pos,_hitUnits,_structures,_damage));
        };
    }, 0.5, [_anchor, _center, _radius, _tornadoSize, _tornadoSpeed, _seed, _tornadoFling, 0]] call CBA_fnc_addPerFrameHandler;
};

if (_duration > 0) then {
    [{
        params ["_anchor"];
        ["lightningstorm", _anchor] call EFUNC(main,stopEffect);
    }, [_anchor], _duration] call CBA_fnc_waitAndExecute;
};

// [anchor, radius, minInterval, maxInterval, damage, nextStrikeTime]
[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_minInterval", "_maxInterval", "_damage", "_nextStrike", "_ambience", "_prevWeather", "_strength"];

    if (isNull _anchor) exitWith {
        if (_ambience) then {
            _prevWeather params ["_overcast", "_rain", "_fog", "_lightnings"];
            60 setOvercast _overcast;
            60 setRain _rain;
            60 setFog _fog;
            60 setLightnings _lightnings;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    if (CBA_missionTime < _nextStrike) exitWith {};
    _args set [5, CBA_missionTime + _minInterval + random (_maxInterval - _minInterval)];

    private _strikePos = _anchor getPos [random _radius, random 360];

    // Real lightning ammo; damaging it makes the engine discharge the bolt.
    private _bolt = createVehicle ["LightningBolt", _strikePos, [], 0, "CAN_COLLIDE"];
    _bolt setDamage 1;

    // The ammo carries the strike but no visible bolt or flash.
    [QGVAR(lightningStrike), [_strikePos, _strength]] call CBA_fnc_globalEvent;

    if (_damage) then {
        {
            if (!(_x isKindOf "VirtualMan_F")) then {
                private _scaled = linearConversion [0, 15, _x distance2D _strikePos, 0.9, 0.1, true];
                [_x, _scaled, "Body", "explosive"] call EFUNC(main,doDamage);
            };
        } forEach (_strikePos nearEntities [["Man", "LandVehicle", "Ship", "StaticWeapon"], 15]);
    };
}, 0.5, [_anchor, _radius, _minInterval, _maxInterval, _damage, 0, _ambience, _prevWeather, _strength]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_4("lightning storm started at %1, radius %2, duration %3, tornado %4",mapGridPosition _pos,_radius,_duration,_tornado));
