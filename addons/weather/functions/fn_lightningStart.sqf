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
    ["_strength", 0.7, [0]]
];

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

DBG(FORMAT_2("lightning storm started, radius %1, duration %2",_radius,_duration));
