#include "..\script_component.hpp"

/*
 * Author: Root
 * Server side of the avalanche boulders. Computes the same seeded boulder paths
 * the clients draw (avalancheRockPaths) and, when the slide is lethal, checks
 * every moving boulder against nearby people and vehicles: damage scales with the
 * boulder's speed and size, and the victim is knocked along its path. Vehicles
 * take hitpoint and hull damage and their crews are hurt.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Travel heading in degrees <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Boulder count <NUMBER>
 * 5: Seed <NUMBER>
 * 6: Mission time the slide started <NUMBER>
 * 7: Boulders damage what they hit <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 120, 200, 25, 40, 1234, CBA_missionTime, true] call root_effects_volcano_fnc_avalancheRocks
 */

params [
    ["_anchor", objNull, [objNull]],
    ["_heading", 0, [0]],
    ["_length", 200, [0]],
    ["_duration", 25, [0]],
    ["_count", 40, [0]],
    ["_seed", 0, [0]],
    ["_startTime", 0, [0]],
    ["_lethal", true, [false]]
];

DBG(FORMAT_1("avalancheRocks called with %1",_this));

if (!isServer || {isNull _anchor}) exitWith {};
if (_count <= 0) exitWith {
    DBG("avalanche boulders off (count 0)");
};

private _rocks = [getPosATL _anchor, _heading, _length, _duration, _count, _seed] call FUNC(avalancheRockPaths);
private _steps = 0;
{_steps = _steps + count (_x select 4)} forEach _rocks;
DBG(FORMAT_4("avalanche boulders: %1 paths (%2 steps), seed %3, lethal %4",count _rocks,_steps,_seed,_lethal));

if (!_lethal) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_rocks", "_startTime", "_lastHit", "_hits"];

    if (isNull _anchor) exitWith {
        DBG(FORMAT_1("avalanche boulders done, %1 hits dealt",_hits));
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _elapsed = CBA_missionTime - _startTime;
    {
        _x params ["_release", "", "_scale", "_radius", "_path"];
        private _t = _elapsed - _release;
        private _step = floor (_t / 0.1);
        if (_t < 0 || {_step >= (count _path) - 1}) then {continue};

        private _pos = _path select _step;
        private _velocity = ((_path select (_step + 1)) vectorDiff _pos) vectorMultiply 10;
        private _speed = vectorMagnitude _velocity;
        if (_speed < 3) then {continue};

        {
            private _target = _x;
            private _netId = netId _target;
            if (!(_target isKindOf "VirtualMan_F") && {CBA_missionTime > (_lastHit getOrDefault [_netId, -10]) + 1}) then {
                _lastHit set [_netId, CBA_missionTime];
                private _impact = ((_speed / 18) min 1) * (0.5 + _scale * 1.5);
                private _push = (vectorNormalized _velocity) vectorMultiply (_speed * 0.5);
                _push set [2, 1 + random 2];

                if (_target isKindOf "CAManBase") then {
                    if (isNull objectParent _target) then {
                        [_target, _impact, selectRandom ["Body", "LeftLeg", "RightLeg", "Head"], "falling", _anchor] call EFUNC(main,doDamage);
                        [QGVAR(avalanchePush), [_target, _push], _target] call CBA_fnc_targetEvent;
                    };
                } else {
                    [_target, _impact * 0.6, true] call EFUNC(main,doHitPointDamage);
                    [_target, _impact * 0.35, "Body", "explosive", _anchor] call EFUNC(main,doDamage);
                    [QGVAR(avalanchePush), [_target, _push vectorMultiply 0.6], _target] call CBA_fnc_targetEvent;
                    {
                        [_x, _impact * 0.3, selectRandom ["Body", "LeftLeg", "RightLeg"], "falling", _anchor] call EFUNC(main,doDamage);
                    } forEach (crew _target);
                };
                _args set [4, (_args select 4) + 1];
                DBG(FORMAT_4("avalanche boulder hit %1 at %2 m/s for %3 at %4",typeOf _target,round _speed,_impact,mapGridPosition _target));
            };
        } forEach ((ASLToAGL _pos) nearEntities [["Man", "LandVehicle", "Ship", "StaticWeapon"], _radius + 1.5]);
    } forEach _rocks;
}, 0.1, [_anchor, _rocks, _startTime, createHashMap, 0]] call CBA_fnc_addPerFrameHandler;
