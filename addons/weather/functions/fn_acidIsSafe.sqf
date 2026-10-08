#include "..\script_component.hpp"

/*
 * Author: Root
 * Decides whether acid rain spares one unit, vehicle or structure. A unit is safe
 * under a roof, wearing any protective gear item, inside a protected vehicle or
 * building class, or standing in a safe zone. A vehicle or structure is safe when
 * its class is protected, when it sits in a safe zone, or when it is flagged with
 * the root_effects_acidSafe variable. A vehicle parked under a roof is safe too.
 *
 * Arguments:
 * 0: Unit, vehicle or structure <OBJECT>
 * 1: Safety lists [gear, vehicle classes, building classes, zone names] <ARRAY>
 *
 * Return Value:
 * True if the acid rain leaves it alone <BOOL>
 *
 * Example:
 * [player, [["H_PilotHelmetFighter_B"], [], [], ["safe_1"]]] call root_effects_weather_fnc_acidIsSafe
 */

params [["_target", objNull, [objNull]], ["_safety", [[], [], [], []], [[]]]];

if (isNull _target) exitWith {true};
_safety params [["_gear", [], [[]]], ["_vehicles", [], [[]]], ["_buildings", [], [[]]], ["_zones", [], [[]]]];

if (_target getVariable ["root_effects_acidSafe", false]) exitWith {true};

// Safe zones: area markers, or triggers/area objects named in the mission.
private _pos = getPosATL _target;
private _inZone = _zones findIf {
    private _name = _x;
    if (markerShape _name isNotEqualTo "") then {
        _pos inArea _name
    } else {
        private _area = missionNamespace getVariable [_name, objNull];
        _area isEqualType objNull && {!isNull _area} && {_pos inArea _area}
    };
} != -1;
if (_inZone) exitWith {true};

if (_target isKindOf "CAManBase") exitWith {
    // Crew are protected by their hull; the vehicle takes the rain instead.
    if (!isNull objectParent _target) exitWith {true};

    if (_gear isNotEqualTo [] && {
        [headgear _target, goggles _target, uniform _target, vest _target, backpack _target, hmd _target] findIf {_x in _gear} != -1
    }) exitWith {true};

    // Standing inside a protected building class.
    if (_buildings isNotEqualTo [] && {
        private _building = nearestBuilding _target;
        !isNull _building
        && {_buildings findIf {_building isKindOf _x} != -1}
        && {(_target distance2D _building) < ((boundingBoxReal _building) select 2)}
    }) exitWith {true};

    // Otherwise only a roof overhead keeps the rain off.
    [_target] call FUNC(isUnderCover)
};

// Vehicles, statics and structures.
if (_vehicles findIf {_target isKindOf _x} != -1) exitWith {true};
if (_buildings findIf {_target isKindOf _x} != -1) exitWith {true};
if ((_target isKindOf "LandVehicle" || {_target isKindOf "Air"}) && {[_target] call FUNC(isUnderCover)}) exitWith {true};

false
