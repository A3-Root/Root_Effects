#include "..\script_component.hpp"

/*
 * Author: Root
 * Makes a light flicker at random while inside an EMP field: short bursts of light
 * (0.05 - 0.5 s) between pauses, never steady. One loop per machine, every 0.05 s,
 * for the lights local here. Kinds:
 * - "gunPlayer": player weapon light; turning it off ends the flicker.
 * - "gunAI": local AI weapon light.
 * - "vehicle": headlights of a local vehicle; switching them off ends the flicker.
 * - "lamp": street lamp, floodlight or power line light (client only).
 * A light that leaves the field goes back on (player, vehicle) or to its saved
 * state (AI); a lamp out of range goes dark, and back on when the field ends in
 * lamps mode 1.
 *
 * Arguments:
 * 0: Light owner <OBJECT>
 * 1: Kind <STRING>
 * 2: Field anchor <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player, "vehicle", _anchor] call root_effects_emp_fnc_empFlickerLocal
 */

params [["_object", objNull, [objNull]], ["_kind", "", [""]], ["_anchor", objNull, [objNull]]];

if (isNull _object || {isNull _anchor}) exitWith {};
if (GVAR(flicker) findIf {(_x select 0) isEqualTo _object} != -1) exitWith {};

// [object, kind, anchor, light on, next switch, weapon]
GVAR(flicker) pushBack [_object, _kind, _anchor, false, CBA_missionTime + 0.1 + random 0.5, currentWeapon _object];
DBG(FORMAT_2("EMP flicker on %1 (%2)",typeOf _object,_kind));

if (GVAR(flickerHandle) >= 0) exitWith {};

GVAR(flickerHandle) = [{
    params ["", "_handle"];

    private _now = CBA_missionTime;
    private _fnc_switch = {
        params ["_object", "_kind", "_on"];
        switch (_kind) do {
            case "gunPlayer": {player action [["GunLightOff", "GunLightOn"] select _on, player]};
            case "gunAI": {_object enableGunLights (["ForceOff", "ForceOn"] select _on)};
            case "vehicle": {_object setPilotLight _on};
            case "lamp": {_object switchLight (["OFF", "ON"] select _on)};
        };
    };
    private _fnc_isOn = {
        params ["_object", "_kind"];
        switch (_kind) do {
            case "gunPlayer";
            case "gunAI": {_object isFlashlightOn (currentWeapon _object)};
            case "vehicle": {isLightOn _object};
            default {true};
        };
    };

    {
        _x params ["_object", "_kind", "_anchor", "_on", "_next", "_weapon"];

        // Still flickering: field running, setting on, light still in the field.
        private _found = GVAR(fields) findIf {(_x select 0) isEqualTo _anchor};
        private _cfg = if (_found == -1) then {createHashMap} else {(GVAR(fields) select _found) select 1};
        private _key = ["flickerGear", "flickerVehicles", "flickerLamps"] select ((["vehicle", "lamp"] find _kind) + 1);
        private _active = !isNull _object && {alive _object || _kind isEqualTo "lamp"} && {_found != -1}
            && {!(_anchor getVariable [QGVAR(ending), false])} && {_cfg getOrDefault [_key, false]};
        if (_active) then {
            _active = switch (_kind) do {
                case "gunPlayer": {_object isEqualTo player && {!isNil QGVAR(playerCfg)} && {currentWeapon player isEqualTo _weapon}};
                case "lamp": {(_object distance (positionCameraToWorld [0, 0, 0])) < 500};
                default {local _object && {(_object getVariable [QGVAR(state), []]) isNotEqualTo []}};
            };
        };

        if (!_active) then {
            GVAR(flicker) set [_forEachIndex, objNull];
            if (isNull _object) then {continue};
            // Light back to what its owner wants, outside the field.
            switch (_kind) do {
                case "gunPlayer": {
                    if (_object isEqualTo player && {currentWeapon player isEqualTo _weapon} && {isNil QGVAR(playerCfg)}) then {
                        if !([player, _kind] call _fnc_isOn) then {[player, _kind, true] call _fnc_switch};
                    };
                };
                case "vehicle": {
                    if (local _object && {(_object getVariable [QGVAR(state), []]) isEqualTo []}) then {_object setPilotLight true};
                };
                case "lamp": {
                    // Field over with lamps mode 1: back on; otherwise dark.
                    private _over = _found == -1 || {_anchor getVariable [QGVAR(ending), false]};
                    _object switchLight (["OFF", "ON"] select (_over && {(_cfg getOrDefault ["lamps", 1]) == 1}));
                };
            };
            continue;
        };

        // Owner switched the light off during a burst: flicker ends, light stays off.
        if (_on && {_kind in ["gunPlayer", "vehicle"]} && {!([_object, _kind] call _fnc_isOn)}) then {
            GVAR(flicker) set [_forEachIndex, objNull];
            continue;
        };
        // Owner switched it on during a pause: back off until the next burst.
        if (!_on && _kind isNotEqualTo "lamp" && {[_object, _kind] call _fnc_isOn}) then {
            [_object, _kind, false] call _fnc_switch;
        };

        if (_now >= _next) then {
            _on = !_on;
            _x set [3, _on];
            [_object, _kind, _on] call _fnc_switch;
            // Bursts 0.05 - 0.5 s; pauses 0.2 - 1.5 s, sometimes a quick stutter.
            private _wait = if (_on) then {0.05 + random 0.45} else {[0.2 + random 1.3, 0.04 + random 0.08] select (random 1 < 0.3)};
            _x set [4, _now + _wait];
        };
    } forEach GVAR(flicker);

    GVAR(flicker) = GVAR(flicker) - [objNull];
    if (GVAR(flicker) isEqualTo []) then {
        GVAR(flickerHandle) = -1;
        _handle call CBA_fnc_removePerFrameHandler;
    };
}, 0.05] call CBA_fnc_addPerFrameHandler;
