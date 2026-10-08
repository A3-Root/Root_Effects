#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies scaled strike damage around an impact point on the server: a real
 * GBU-12 detonation at the centre, then extra damage on top that falls off
 * towards the edge of the radius. Units, vehicles and their crews are hurt,
 * and buildings, walls and trees are knocked down when the damage is high
 * enough, so 100% flattens the core of the strike.
 *
 * Arguments:
 * 0: Impact position ATL <ARRAY>
 * 1: Damage radius in meters <NUMBER>
 * 2: Damage strength 0..1 <NUMBER>
 * 3: Damage source <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosATL player, 30, 0.5] call root_effects_strikes_fnc_strikeDamage
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 30, [0]], ["_strength", 1, [0]], ["_source", objNull, [objNull]]];

if (!isServer) exitWith {};
_strength = (_strength max 0) min 1;
if (_strength <= 0) exitWith {};
_radius = _radius max 1;

DBG(FORMAT_3("strike damage at %1, radius %2, strength %3",mapGridPosition _pos,_radius,_strength));

// The bomb carries the engine blast, crater and sound for everyone.
private _bomb = createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "CAN_COLLIDE"];
_bomb setPosATL (_pos vectorAdd [0, 0, 0.5]);
triggerAmmo _bomb;

private _killed = 0;
private _hit = 0;
{
    private _target = _x;
    _hit = _hit + 1;
    if (!(_target isKindOf "VirtualMan_F")) then {
        private _damage = _strength * linearConversion [0, _radius, _target distance2D _pos, 1, 0.25, true];

        if (_damage >= 0.9 && EGVAR(main,damageAllowed)) exitWith {
            // Core of a full-strength strike: nothing survives, ACE or not.
            {_x setDamage 1} forEach (crew _target);
            _target setDamage 1;
            _killed = _killed + 1;
        };

        if (_target isKindOf "CAManBase") then {
            // ACE wounds need far more than vanilla's 0..1 to matter.
            private _scaled = [_damage, _damage * 4] select EGVAR(main,aceMedicalLoaded);
            [_target, _scaled, selectRandom ["Body", "Head", "LeftLeg", "RightLeg", "LeftArm", "RightArm"], "explosive", _source] call EFUNC(main,doDamage);
        } else {
            [_target, _damage, true] call EFUNC(main,doHitPointDamage);
            [_target, _damage, "Body", "explosive", _source] call EFUNC(main,doDamage);
            {
                [_x, _damage * 0.8, selectRandom ["Body", "Head", "LeftLeg", "RightLeg"], "explosive", _source] call EFUNC(main,doDamage);
            } forEach (crew _target);
        };
    };
} forEach (_pos nearEntities [["Man", "LandVehicle", "Air", "Ship", "StaticWeapon"], _radius]);
DBG(FORMAT_2("strike damage hit %1 entities, %2 destroyed outright",_hit,_killed));

if (!(EGVAR(main,damageAllowed))) exitWith {};

// Structures get a gentler falloff than units so a full strength hit levels
// roughly the inner half of the radius rather than a tiny spot.
private _structures = nearestTerrainObjects [_pos, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "TRANSMITTER", "LIGHTHOUSE", "WATERTOWER", "POWER LINES", "TREE", "SMALL TREE", "BUSH", "WALL", "FENCE", "HIDE"], _radius, false, true];
_structures = _structures + nearestObjects [_pos, ["Building", "House", "Wall"], _radius, true];
_structures = _structures arrayIntersect _structures;

private _batch = 0;
{
    private _object = _x;
    if (alive _object) then {
        private _damage = _strength * linearConversion [0, _radius, _object distance2D _pos, 1.3, 0.5, true];
        private _final = [((damage _object) + _damage) min 0.85, 1] select (_damage >= 0.9);
        // Spread the collapses over a moment so a dense town does not drop
        // every building in the same frame.
        [{
            params ["_object", "_final"];
            if (!isNull _object) then {
                _object setDamage _final;
            };
        }, [_object, _final], 0.2 + (floor (_batch / 10)) * 0.15] call CBA_fnc_waitAndExecute;
        _batch = _batch + 1;
    };
} forEach _structures;
DBG(FORMAT_1("strike damage queued %1 structures",_batch));
