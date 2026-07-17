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
 * 3: Damage what the collapse throws <BOOL>
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
    ["_lethal", true, [false]]
];

if (!isServer) exitWith {};
if (!(["singularity"] call EFUNC(main,isEffectEnabled))) exitWith {};

_radius = (_radius max 50) min 300;
_chargeTime = _chargeTime max 2;
_lethal = _lethal && GVAR(allowDamage);

private _anchor = ["singularity", QGVAR(singularityLocal), [_radius, _chargeTime], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_anchor", "_radius", "_lethal"];
    if (isNull _anchor) exitWith {};

    private _center = getPosATL _anchor;

    {
        private _target = _x;
        if (!(_target isKindOf "VirtualMan_F")) then {
            private _falloff = linearConversion [0, _radius, _target distance2D _center, 1, 0.25, true];

            // setVelocity only takes on the owning machine, same reason the
            // damage helpers route: anything a player owns is remote here.
            [QGVAR(singularityFlingLocal), [_target, _falloff], _target] call CBA_fnc_targetEvent;

            if (_lethal) then {
                private _damage = _falloff * (0.6 + random 0.4);
                if (_target isKindOf "CAManBase") then {
                    [_target, _damage, selectRandom ["Body", "Head", "LeftLeg", "RightLeg"], "explosive", _anchor] call EFUNC(main,doDamage);
                } else {
                    [_target, _damage] call EFUNC(main,doDamage);
                };
            };
        };
    } forEach (_center nearEntities [["Man", "LandVehicle", "Ship"], _radius]);

    // The anomaly collapses with the pulse; the visuals fade on their own.
    [{
        params ["_anchor"];
        ["singularity", _anchor] call EFUNC(main,stopEffect);
    }, [_anchor], 8] call CBA_fnc_waitAndExecute;
}, [_anchor, _radius, _lethal], _chargeTime] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("singularity charging, radius %1, charge %2",_radius,_chargeTime));
