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
    ["_ambience", true, [false]]
];

if (!isServer) exitWith {};
if (!(["lightningstorm"] call EFUNC(main,isEffectEnabled))) exitWith {};

_minInterval = _minInterval max 1;
_maxInterval = _maxInterval max _minInterval;
_damage = _damage && GVAR(allowDamage);

private _anchor = ["lightningstorm", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// A clear blue sky undercuts the storm, so the cloud cover is pulled over for
// as long as it runs and eased back afterwards.
private _prevOvercast = overcast;
if (_ambience) then {
    0 setOvercast 0.9;
    forceWeatherChange;
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
    _args params ["_anchor", "_radius", "_minInterval", "_maxInterval", "_damage", "_nextStrike", "_ambience", "_prevOvercast"];

    if (isNull _anchor) exitWith {
        if (_ambience) then {
            60 setOvercast _prevOvercast;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    if (CBA_missionTime < _nextStrike) exitWith {};
    _args set [5, CBA_missionTime + _minInterval + random (_maxInterval - _minInterval)];

    private _strikePos = _anchor getPos [random _radius, random 360];

    // Real lightning ammo; damaging it makes the engine discharge the bolt.
    private _bolt = createVehicle ["LightningBolt", _strikePos, [], 0, "CAN_COLLIDE"];
    _bolt setDamage 1;

    if (_damage) then {
        {
            if (!(_x isKindOf "VirtualMan_F")) then {
                private _scaled = linearConversion [0, 15, _x distance2D _strikePos, 0.9, 0.1, true];
                [_x, _scaled, "Body", "explosive"] call EFUNC(main,doDamage);
            };
        } forEach (_strikePos nearEntities [["Man", "LandVehicle"], 15]);
    };
}, 0.5, [_anchor, _radius, _minInterval, _maxInterval, _damage, 0, _ambience, _prevOvercast]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_2("lightning storm started, radius %1, duration %2",_radius,_duration));
