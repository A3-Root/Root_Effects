#include "..\script_component.hpp"

/*
 * Author: Root, based on community carpet strike scripts by DCON and M9SD
 * Runs a carpet bombing strike on the server: sends bombers over the target
 * line and after the drop delay releases a stick of real bombs walking along
 * it, one bomb every 0.3 seconds. The engine replicates the explosions and
 * damage; only the jet roar and the falling bomb whistles are client side
 * sound events.
 *
 * Arguments:
 * 0: Center position ATL of the bombing line <ARRAY>
 * 1: Bomber class for the flyby <STRING>
 * 2: Number of bombers <NUMBER>
 * 3: Bomb ammo class <STRING>
 * 4: Attack heading in degrees <NUMBER>
 * 5: Number of bombs, capped by the server setting <NUMBER>
 * 6: Bombing line length in meters <NUMBER>
 * 7: Seconds between the flyby start and the first impact <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], "B_Plane_CAS_01_dynamicLoadout_F", 1, "Bo_Mk82", 45, 50, 150, 34] call root_effects_strikes_fnc_carpetStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_planeClass", "B_Plane_CAS_01_dynamicLoadout_F", [""]],
    ["_planeCount", 1, [0]],
    ["_bombClass", "Bo_Mk82", [""]],
    ["_heading", 0, [0]],
    ["_bombCount", 50, [0]],
    ["_length", 150, [0]],
    ["_dropDelay", 35, [0]]
];

if (!isServer) exitWith {};
if (!(["carpetstrike"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (!GVAR(allowDamage) || {!EGVAR(main,damageAllowed)}) exitWith {
    DBG("carpet strike rejected, damage is disabled by settings");
};
if (!isClass (configFile >> "CfgAmmo" >> _bombClass)) exitWith {
    DBG(FORMAT_1("carpet strike rejected, unknown bomb class %1",_bombClass));
};
if (!isClass (configFile >> "CfgVehicles" >> _planeClass)) exitWith {
    DBG(FORMAT_1("carpet strike rejected, unknown plane class %1",_planeClass));
};

_planeCount = (_planeCount max 1) min 4;
_bombCount = (_bombCount max 1) min GVAR(maxBombs);
_length = _length max 50;
_dropDelay = _dropDelay max 5;

[_planeClass, ATLToASL _pos, true, 1000, 5000, floor (_heading / 45), 1, _planeCount] call zen_modules_fnc_moduleAmbientFlyby;

[{
    params ["_pos", "_bombClass", "_heading", "_bombCount", "_length"];

    // Jet roar for everyone close to the target line.
    [QGVAR(carpetSound), [_pos, "jet"]] call CBA_fnc_globalEvent;

    private _firstImpact = (_pos getPos [_length / 2, _heading + 180]) vectorAdd [0, 0, 200];
    private _increment = _length / _bombCount;

    // Walk the stick of bombs along the line, one drop per step.
    // [firstImpact, bombClass, heading, increment, index, total]
    [{
        params ["_args", "_handle"];
        _args params ["_firstImpact", "_bombClass", "_heading", "_increment", "_index", "_total"];

        if (_index >= _total) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };
        _args set [4, _index + 1];

        private _dropPos = ((_firstImpact select [0, 2]) + [200]) vectorAdd [random 40 - 20, random 40 - 20, random 10 - 5];
        if (_index > 0) then {
            private _linePos = _firstImpact getPos [_increment * _index, _heading];
            _dropPos = [_linePos select 0, _linePos select 1, 200] vectorAdd [random 40 - 20, random 40 - 20, random 10 - 5];
        };

        private _bomb = createVehicle [_bombClass, _dropPos, [], 0, "CAN_COLLIDE"];
        _bomb setPosASL (ATLToASL _dropPos);
        _bomb setVectorDirAndUp [[0, 0, -1], [0, 0.8, 0]];
        _bomb setVelocityModelSpace [0, 50, -50];

        // Falling whistle at the projected impact point.
        [QGVAR(carpetSound), [ASLToATL getPosASL _bomb, "whistle"]] call CBA_fnc_globalEvent;
    }, 0.3, [_firstImpact, _bombClass, _heading, _increment, 0, _bombCount]] call CBA_fnc_addPerFrameHandler;
}, [_pos, _bombClass, _heading, _bombCount, _length], _dropDelay] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("carpet strike inbound, %1 bombs over %2 meters",_bombCount,_length));
