#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts an artillery barrage on the server. In lethal mode real shells are
 * spawned above random impact points so the engine handles visuals and
 * damage everywhere. In non-lethal and sound-only mode a lightweight impact
 * event is broadcast instead and clients render it locally.
 *
 * Arguments:
 * 0: Position ATL of the barrage center <ARRAY>
 * 1: Barrage radius in meters <NUMBER>
 * 2: Mode: 0 lethal, 1 non-lethal visuals, 2 sound and shake only <NUMBER>
 * 3: Shell ammo class used in lethal mode <STRING>
 * 4: Delay between impacts in seconds <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500, 0, "Sh_155mm_AMOS", 3] call root_effects_battlescripts_fnc_artilleryStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 500, [0]],
    ["_mode", 0, [0]],
    ["_shellClass", "Sh_155mm_AMOS", [""]],
    ["_fireDelay", 3, [0]]
];

if (!isServer) exitWith {};
if (!(["artillery"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (!isClass (configFile >> "CfgAmmo" >> _shellClass)) exitWith {
    DBG(FORMAT_1("artillery start rejected, unknown shell class %1",_shellClass));
};

_fireDelay = _fireDelay max 1;

// Damage kill-switches downgrade a lethal barrage to visuals only.
if (_mode == 0 && {!GVAR(allowDamage) || {!EGVAR(main,damageAllowed)}}) then {
    _mode = 1;
};

private _anchor = ["artillery", "", [], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_mode", "_shellClass"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _impactPos = _anchor getPos [random _radius, random 360];

    if (_mode == 0) then {
        // Real shell falling onto the impact point; the engine replicates
        // explosion, sound and damage to every machine on its own.
        private _shell = createVehicle [_shellClass, _impactPos vectorAdd [0, 0, 100], [], 0, "CAN_COLLIDE"];
        _shell setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
        _shell setVelocity [0, 0, -100];
    } else {
        [QGVAR(artilleryImpact), [_impactPos, _mode == 2]] call CBA_fnc_globalEvent;
    };
}, _fireDelay, [_anchor, _radius, _mode, _shellClass]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_3("artillery started, radius %1, mode %2, shell %3",_radius,_mode,_shellClass));
