#include "..\script_component.hpp"

/*
 * Author: Root
 * Releases real, physically simulated boulders down a scree avalanche on the server.
 * Each boulder is a physics carrier (an engine PhysX prop made invisible) wearing a
 * scaled rock model, pushed downhill and spun, so it bounces off the terrain, rolls
 * into whatever is in the way and comes to rest on its own. A watcher checks every
 * moving boulder against nearby people and vehicles and, when the slide is lethal,
 * deals damage scaled by the boulder's speed and size and knocks the victim along.
 * Every boulder is cleaned up a while after it stops or once the slide is over.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Travel heading in degrees <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Boulder count <NUMBER>
 * 5: Boulders damage what they hit <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 120, 200, 25, 40, true] call root_effects_volcano_fnc_avalancheRocks
 */

params [
    ["_anchor", objNull, [objNull]],
    ["_heading", 0, [0]],
    ["_length", 200, [0]],
    ["_duration", 25, [0]],
    ["_count", 40, [0]],
    ["_lethal", true, [false]]
];

if (!isServer || {isNull _anchor}) exitWith {};

_count = round ((_count max 0) min 80);
if (_count == 0) exitWith {};

// First engine physics prop available; barrels and tyres are PhysX in vanilla.
private _carrierClass = ["Land_BarrelEmpty_F", "Land_BarrelSand_F", "Land_Tyre_F", "Land_GarbageBarrel_01_F"] select {
    (toLowerANSI getText (configFile >> "CfgVehicles" >> _x >> "simulation")) isEqualTo "thingx"
} param [0, ""];
if (_carrierClass isEqualTo "") exitWith {
    DBG("avalanche rocks: no physics carrier class available, boulders skipped");
};

private _models = [
    "\a3\rocks_f\Blunt\BluntStone_01.p3d",
    "\a3\rocks_f\Blunt\BluntStone_02.p3d",
    "\a3\rocks_f\Sharp\sharpStone_01.p3d",
    "\a3\rocks_f\Sharp\sharpStone_02.p3d"
];

private _speed = (_length / _duration) max 4;
private _rocks = [];
_anchor setVariable [QGVAR(avalancheRocks), _rocks];
private _attached = _anchor getVariable [QEGVAR(main,attachedObjects), []];
_anchor setVariable [QEGVAR(main,attachedObjects), _attached];

// Release: boulders break off the head of the slide over the first two thirds of
// it, so the rock front keeps feeding while the dust rolls down.
private _interval = ((_duration * 0.66) / _count) max 0.15;
[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_heading", "_speed", "_carrierClass", "_models", "_rocks", "_attached", "_left"];

    if (isNull _anchor || _left <= 0) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };
    _args set [7, _left - 1];

    private _scale = 0.18 + random 0.32;
    private _spawnPos = (getPosATL _anchor) getPos [2 + random 10, _heading + (random 70 - 35)];
    _spawnPos set [2, 1.5 + random 2];

    private _carrier = createVehicle [_carrierClass, _spawnPos, [], 0, "CAN_COLLIDE"];
    _carrier setPosATL _spawnPos;
    // Invisible but still solid: hiding an object would also take its collision away.
    {
        _carrier setObjectTextureGlobal [_forEachIndex, "#(argb,8,8,3)color(0,0,0,0)"];
    } forEach (getObjectTextures _carrier);
    _carrier setMass (800 * _scale * 4);

    private _rock = createSimpleObject [selectRandom _models, getPosASL _carrier];
    _rock setObjectScale _scale;
    _rock attachTo [_carrier, [0, 0, 0.1]];
    _rock setDir random 360;

    private _launch = _speed * (0.8 + random 0.6);
    _carrier setVelocity [sin _heading * _launch, cos _heading * _launch, 1 + random 3];
    _carrier addTorque [random 4000 - 2000, random 4000 - 2000, random 1000 - 500];

    _rocks pushBack [_carrier, _rock, _scale, CBA_missionTime];
    _attached append [_carrier, _rock];
}, _interval, [_anchor, _heading, _speed, _carrierClass, _models, _rocks, _attached, _count]] call CBA_fnc_addPerFrameHandler;

// Impact watcher: moving boulders hurt and shove what they run into.
[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_rocks", "_lethal", "_lastHit", "_endTime"];

    if (isNull _anchor || CBA_missionTime > _endTime) exitWith {
        {
            _x params ["_carrier", "_rock"];
            deleteVehicle _rock;
            deleteVehicle _carrier;
        } forEach _rocks;
        _rocks resize 0;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    {
        _x params ["_carrier", "_rock", "_scale", "_born"];
        if (isNull _carrier) then {continue};

        private _velocity = velocity _carrier;
        private _speed = vectorMagnitude _velocity;

        // Settled boulders are cleared after a while so the slope does not fill up.
        if (_speed < 0.3 && {CBA_missionTime - _born > 12}) then {
            deleteVehicle _rock;
            deleteVehicle _carrier;
            continue;
        };

        if (_lethal && _speed > 3) then {
            private _reach = 1.2 + _scale * 3;
            {
                private _target = _x;
                private _netId = netId _target;
                if (
                    !(_target isKindOf "VirtualMan_F")
                    && {CBA_missionTime > (_lastHit getOrDefault [_netId, -10]) + 1}
                ) then {
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
                    DBG(FORMAT_3("avalanche boulder hit %1 at %2 m/s for %3",typeOf _target,round _speed,_impact));
                };
            } forEach ((getPosATL _carrier) nearEntities [["Man", "LandVehicle", "Ship", "StaticWeapon"], _reach]);
        };
    } forEach _rocks;
}, 0.1, [_anchor, _rocks, _lethal, createHashMap, CBA_missionTime + _duration + 10]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_4("avalanche releasing %1 boulders (%2), heading %3, lethal %4",_count,_carrierClass,_heading,_lethal));
