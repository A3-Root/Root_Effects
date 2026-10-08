#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs a scree avalanche on the server: creates the anchor, broadcasts the
 * dust and scree cascade to all clients (JIP safe) and releases real physics
 * boulders down the corridor that crush and shove whatever they hit when the
 * slide is lethal. The instance removes itself once the slide has run out.
 *
 * Arguments:
 * 0: Head position ATL of the slide <ARRAY>
 * 1: Travel heading in degrees, -1 to follow the slope downhill <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Crush units caught in the corridor <BOOL>
 * 5: Comma separated vehicle classes to roll down the slope, "" for none <STRING>
 * 6: Number of physical boulders released down the slope <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], -1, 200, 25, true, "Land_MetalBarrel_F", 40] call root_effects_volcano_fnc_avalancheStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_heading", -1, [0]],
    ["_length", 200, [0]],
    ["_duration", 25, [0]],
    ["_lethal", true, [false]],
    ["_objects", "", [""]],
    ["_rockCount", 40, [0]]
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

// Optional real props tumbling down the corridor alongside the particle rocks.
// The curator names one or more vehicle classes; each spawned prop is tracked on
// the anchor so the termination module and the slide cleanup remove any that
// linger.
private _classes = (_objects splitString ",") apply {trim _x};
_classes = _classes select {_x isNotEqualTo "" && {isClass (configFile >> "CfgVehicles" >> _x)}};
if (_classes isNotEqualTo []) then {
    private _spawned = [];
    _anchor setVariable [QEGVAR(main,attachedObjects), _spawned];
    private _speed = _length / _duration;

    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_classes", "_heading", "_speed", "_spawned", "_endTime"];

        if (isNull _anchor || CBA_missionTime > _endTime) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        // Drop the prop just above the head of the slide, scattered across the
        // corridor width, and shove it down the slope.
        private _spawnPos = (getPosATL _anchor) getPos [3 + random 8, _heading + (random 50 - 25)];
        private _object = createVehicle [selectRandom _classes, _spawnPos, [], 0, "CAN_COLLIDE"];
        _object setPosATL (_spawnPos vectorAdd [0, 0, 2]);
        _object setVelocity [sin _heading * _speed, cos _heading * _speed, 1];
        _spawned pushBack _object;

        // Clear each prop a few seconds after it has tumbled so they do not pile
        // up at the foot of the slope for the whole slide.
        [{
            params ["_object"];
            deleteVehicle _object;
        }, [_object], 8] call CBA_fnc_waitAndExecute;
    }, 0.5, [_anchor, _classes, _heading, _speed, _spawned, CBA_missionTime + _duration]] call CBA_fnc_addPerFrameHandler;
};

// Real boulders with physics roll down the corridor and do the damage on contact.
[_anchor, _heading, _length, _duration, _rockCount, _lethal] call FUNC(avalancheRocks);

[{
    params ["_anchor"];
    ["avalanche", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], _duration + 12] call CBA_fnc_waitAndExecute;

DBG(FORMAT_4("avalanche started at %1, heading %2, length %3, boulders %4",mapGridPosition _pos,round _heading,_length,_rockCount));
