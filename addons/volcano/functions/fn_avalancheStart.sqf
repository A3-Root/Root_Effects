#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs a scree avalanche on the server: creates the anchor, broadcasts the
 * cascade to all clients (JIP safe) and, when lethal, crushes units caught in
 * the corridor as the rock front travels down it. The instance removes itself
 * once the slide has run out.
 *
 * Arguments:
 * 0: Head position ATL of the slide <ARRAY>
 * 1: Travel heading in degrees, -1 to follow the slope downhill <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Crush units caught in the corridor <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], -1, 200, 25, true] call root_effects_volcano_fnc_avalancheStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_heading", -1, [0]],
    ["_length", 200, [0]],
    ["_duration", 25, [0]],
    ["_lethal", true, [false]]
];

if (!isServer) exitWith {};
if (!(["avalanche"] call EFUNC(main,isEffectEnabled))) exitWith {};

_length = (_length max 50) min 800;
_duration = _duration max 10;
_lethal = _lethal && GVAR(allowLethality);

// Rock runs downhill unless the curator forced a direction. The surface normal
// leans away from the slope, so its horizontal part points down it.
if (_heading < 0) then {
    private _normal = surfaceNormal _pos;
    private _flat = [_normal select 0, _normal select 1];

    _heading = if ((vectorMagnitude _flat) < 0.01) then {
        // Flat ground gives no downhill; fall back to a random direction.
        random 360
    } else {
        (_normal select 0) atan2 (_normal select 1)
    };
};

private _anchor = ["avalanche", QGVAR(avalancheLocal), [_heading, _length, _duration], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

if (_lethal) then {
    // The kill band tracks the rock front rather than the whole corridor, so
    // getting clear ahead of it actually works.
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_heading", "_length", "_duration", "_startTime"];

        if (isNull _anchor) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _progress = (CBA_missionTime - _startTime) / _duration;
        if (_progress > 1) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _head = getPosATL _anchor;
        private _frontPos = _head getPos [_length * _progress, _heading];

        {
            if (!(_x isKindOf "VirtualMan_F")) then {
                [_x, 0.6 + random 0.4, "Body", "explosive", _anchor] call EFUNC(main,doDamage);
            };
        } forEach (_frontPos nearEntities [["Man", "LandVehicle"], 18]);
    }, 1, [_anchor, _heading, _length, _duration, CBA_missionTime]] call CBA_fnc_addPerFrameHandler;
};

[{
    params ["_anchor"];
    ["avalanche", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], _duration + 12] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("avalanche started, heading %1, length %2",_heading,_length));
