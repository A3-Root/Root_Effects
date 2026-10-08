#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs a gravity anomaly strike on the server: creates the anchor, broadcasts
 * the charge and collapse visuals to all clients (JIP safe) and, once the
 * charge completes, throws everything inside the radius into the air. The
 * fling is routed to each object's owner because velocity only applies there.
 *
 * Arguments:
 * 0: Anomaly center position ATL <ARRAY>
 * 1: Effect radius in meters <NUMBER>
 * 2: Charge time in seconds before the collapse <NUMBER>
 * 3: Damage strength 0..1, 0 for none (old BOOL accepted) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 120, 6, true] call root_effects_strikes_fnc_singularityStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 120, [0]],
    ["_chargeTime", 6, [0]],
    ["_lethal", 1, [0, false]]
];

DBG(FORMAT_1("singularityStart called with %1",_this));

if (!isServer) exitWith {};
if (!(["singularity"] call EFUNC(main,isEffectEnabled))) exitWith {};

_radius = (_radius max 50) min 300;
// The alarm must finish before the collapse, so the charge covers at least one.
_chargeTime = _chargeTime max SINGULARITY_MIN_CHARGE;
if (_lethal isEqualType false) then {_lethal = [0, 1] select _lethal};
if (!GVAR(allowDamage)) then {_lethal = 0};

private _anchor = ["singularity", QGVAR(singularityLocal), [_radius, _chargeTime], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_anchor", "_radius", "_lethal"];
    if (isNull _anchor) exitWith {};

    private _center = getPosATL _anchor;

    // Everything loose is thrown: people, vehicles, boats, statics, crates and physics
    // props. Heavier things go less far. setVelocity only takes on the owning machine,
    // so each object is routed to its owner.
    private _thrown = 0;
    {
        private _target = _x;
        if (!(_target isKindOf "VirtualMan_F") && _target != _anchor && {alive _target || {_target isKindOf "ThingX"}} && {isNull attachedTo _target}) then {
            private _falloff = linearConversion [0, _radius, _target distance2D _center, 1, 0.25, true];
            private _massScale = linearConversion [500, 40000, getMass _target, 1, 0.55, true];
            [QGVAR(singularityFlingLocal), [_target, _falloff * _massScale], _target] call CBA_fnc_targetEvent;
            _thrown = _thrown + 1;
        };
    } forEach (nearestObjects [_center, ["CAManBase", "LandVehicle", "Ship", "StaticWeapon", "Air", "ThingX", "ReammoBox_F"], _radius]);
    DBG(FORMAT_3("singularity collapsed at %1, threw %2 objects, damage %3",mapGridPosition _center,_thrown,_lethal));

    // Throw first, kill after: about a second into the throw, while everyone is
    // still in the air, every unit inside the zone (on foot or in a vehicle) dies
    // and the collapse goes off like a heavy bomb (real GBU-12 at the core plus
    // scaled damage over the whole radius, buildings included).
    if (_lethal > 0) then {
        [{
            params ["_center", "_radius", "_lethal", "_anchor", "_damageRadius"];
            private _victims = (_center nearEntities [["CAManBase"], _radius]) select {alive _x && {!(_x isKindOf "VirtualMan_F")}};
            {
                _victims append ((crew _x) select {alive _x});
            } forEach (_center nearEntities [["LandVehicle", "Air", "Ship", "StaticWeapon"], _radius]);
            _victims = _victims arrayIntersect _victims;
            {_x setDamage 1} forEach _victims;
            DBG(FORMAT_3("singularity aftermath at %1: %2 units killed in mid air within %3 m",mapGridPosition _center,count _victims,_radius));
            // Everything built or grown inside the radius is destroyed outright.
            [_center, _damageRadius, _lethal, _anchor, true] call FUNC(strikeDamage);
        }, [_center, _radius * 1.5, _lethal, _anchor, _radius], 1.1] call CBA_fnc_waitAndExecute;
    };

    // The anomaly collapses with the pulse; the visuals fade on their own.
    [{
        params ["_anchor"];
        ["singularity", _anchor] call EFUNC(main,stopEffect);
    }, [_anchor], 8] call CBA_fnc_waitAndExecute;
}, [_anchor, _radius, _lethal], _chargeTime] call CBA_fnc_waitAndExecute;

DBG(FORMAT_4("singularity charging at %1, radius %2, charge %3, damage %4",mapGridPosition _anchor,_radius,_chargeTime,_lethal));
