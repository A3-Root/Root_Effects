#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs a napalm strike on the server: sends a plane over the target line,
 * walks a stick of real bombs along it and ignites a burning corridor in
 * their wake. The fire wall is rendered locally by every client; the server
 * only runs the periodic burn damage to units inside the corridor and removes
 * the instance once the fire dies. Without damage allowed the bombs are
 * skipped and the corridor simply lights up.
 *
 * Arguments:
 * 0: Center position ATL of the fire line <ARRAY>
 * 1: Aircraft class for the flyby <STRING>
 * 2: Attack heading in degrees <NUMBER>
 * 3: Fire line length in meters <NUMBER>
 * 4: Burn duration in seconds <NUMBER>
 * 5: Apply burn damage <BOOL>
 * 6: Seconds between the flyby start and the first bomb <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], "B_Plane_CAS_01_dynamicLoadout_F", 0, 150, 180, true, 20] call root_effects_strikes_fnc_napalmStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_planeClass", "B_Plane_CAS_01_dynamicLoadout_F", [""]],
    ["_heading", 0, [0]],
    ["_length", 150, [0]],
    ["_duration", 180, [0]],
    ["_damage", true, [false]],
    ["_dropDelay", 20, [0]]
];

if (!isServer) exitWith {};
if (!(["napalmstrike"] call EFUNC(main,isEffectEnabled))) exitWith {};
if (!isClass (configFile >> "CfgVehicles" >> _planeClass)) exitWith {
    DBG(FORMAT_1("napalm start rejected, unknown plane class %1",_planeClass));
};

_length = _length max 50;
_duration = _duration max 15;
_damage = _damage && GVAR(allowDamage);
_dropDelay = _dropDelay max 5;

// Attack run announcing the drop.
[_planeClass, ATLToASL _pos, true, 300, 4000, floor (_heading / 45), 2, 1] call zen_modules_fnc_moduleAmbientFlyby;

[{
    params ["_pos", "_heading", "_length", "_duration", "_damage"];

    // Real ordnance only when this strike is allowed to hurt anyone; a visual
    // strike goes straight to the fire so nothing is destroyed by the drop.
    if (!_damage) exitWith {
        [_pos, _heading, _length, _duration, _damage] call FUNC(napalmIgnite);
    };

    [QGVAR(carpetSound), [_pos, "jet"]] call CBA_fnc_globalEvent;

    private _firstDrop = _pos getPos [_length / 2, _heading + 180];
    private _bombCount = round (_length / 15) max 4;
    // Space the drops so the first and last land on the two ends of the line,
    // covering its whole length rather than stopping a step short.
    private _increment = _length / (_bombCount - 1);

    // Walk the stick of bombs along the fire line, one drop per step.
    // [firstDrop, heading, increment, index, total]
    [{
        params ["_args", "_handle"];
        _args params ["_firstDrop", "_heading", "_increment", "_index", "_total"];

        if (_index >= _total) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };
        _args set [3, _index + 1];

        private _linePos = _firstDrop getPos [_increment * _index, _heading];
        // Drop from directly above each line position and fall straight down so
        // the craters land on the line instead of drifting off with a fixed
        // world-space velocity that ignored the attack heading.
        private _dropPos = [_linePos select 0, _linePos select 1, 150] vectorAdd [random 10 - 5, random 10 - 5, 0];

        private _bomb = createVehicle ["Bo_Mk82", _dropPos, [], 0, "CAN_COLLIDE"];
        _bomb setPosASL (ATLToASL _dropPos);
        _bomb setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
        _bomb setVelocity [0, 0, -80];

        [QGVAR(carpetSound), [ASLToATL getPosASL _bomb, "whistle"]] call CBA_fnc_globalEvent;
    }, 0.25, [_firstDrop, _heading, _increment, 0, _bombCount]] call CBA_fnc_addPerFrameHandler;

    // Let the last bomb land before the corridor catches.
    [{
        _this call FUNC(napalmIgnite);
    }, [_pos, _heading, _length, _duration, _damage], _bombCount * 0.25 + 2] call CBA_fnc_waitAndExecute;
}, [_pos, _heading, _length, _duration, _damage], _dropDelay] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("napalm strike inbound, length %1, duration %2",_length,_duration));
