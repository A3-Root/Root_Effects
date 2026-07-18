#include "..\script_component.hpp"

/*
 * Author: Root
 * Fires an orbital laser strike on the server: broadcasts the beam visuals
 * to all clients and detonates a large explosion with radial damage at the
 * target point once the beam has burned for half its duration. One shot per
 * call; the visuals clean themselves up.
 *
 * Arguments:
 * 0: Target position ATL <ARRAY>
 * 1: Charge up time in seconds <NUMBER>
 * 2: Beam duration in seconds <NUMBER>
 * 3: Beam color as [r, g, b] <ARRAY>
 * 4: Apply damage <BOOL>
 * 5: Damage radius in meters <NUMBER>
 * 6: Beam thickness multiplier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 5, 3, [1, 0.2, 0.2], true, 30, 1] call root_effects_strikes_fnc_laserStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_chargeTime", 5, [0]],
    ["_beamTime", 3, [0]],
    ["_color", [1, 0.2, 0.2], [[]], 3],
    ["_damage", true, [false]],
    ["_damageRadius", 30, [0]],
    ["_thickness", 1, [0]]
];

if (!isServer) exitWith {};
if (!(["laserstrike"] call EFUNC(main,isEffectEnabled))) exitWith {};

_chargeTime = _chargeTime max 1;
_beamTime = _beamTime max 1;
_thickness = _thickness max 0.5;
_damage = _damage && GVAR(allowDamage);

[QGVAR(laserLocal), [_pos, _chargeTime, _beamTime, _color, _thickness]] call CBA_fnc_globalEvent;

[{
    params ["_pos", "_damage", "_damageRadius"];

    // The engine explosion carries the audiovisual impact for everyone.
    private _explosion = createVehicle ["HelicopterExploBig", _pos, [], 0, "CAN_COLLIDE"];
    _explosion setPosATL _pos;

    if (_damage) then {
        {
            if (!(_x isKindOf "VirtualMan_F")) then {
                private _scaled = linearConversion [0, _damageRadius, _x distance2D _pos, 1, 0.2, true];
                [_x, _scaled, "Body", "explosive"] call EFUNC(main,doDamage);
            };
        } forEach (_pos nearEntities [["Man", "LandVehicle", "Air", "Ship"], _damageRadius]);
    };
}, [_pos, _damage, _damageRadius], _chargeTime + (_beamTime / 2)] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("laser strike fired, charge %1, beam %2",_chargeTime,_beamTime));
