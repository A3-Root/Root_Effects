#include "..\script_component.hpp"

/*
 * Author: Root
 * Field loop on every machine, every 0.5 s. Works on the units and vehicles
 * local here: knocks them out when the shockwave reaches them (plus the effect
 * delay) or, when they enter later, after the grace time; keeps them knocked out
 * while affected; recovers them on leaving (restore on) or when the field ends.
 * Also keeps the ACRE signal hook and UAV disconnects up to date.
 *
 * Arguments:
 * 0: PFH arguments <ARRAY>
 * 1: PFH handle <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [FUNC(empLoop), 0.5] call CBA_fnc_addPerFrameHandler
 */

params ["", "_handle"];

// Drop ended fields, pick up modified settings.
GVAR(fields) = GVAR(fields) select {!isNull (_x select 0)};
{
    private _anchor = _x select 0;
    private _version = _anchor getVariable [QGVAR(cfgVer), -1];
    if (_version > (_x select 2)) then {
        _x set [1, createHashMapFromArray (_anchor getVariable [QGVAR(cfg), []])];
        _x set [2, _version];
    };
} forEach GVAR(fields);

private _now = CBA_missionTime;
private _entities = (allUnits select {local _x && {!(_x isKindOf "VirtualMan_F")}}) + (vehicles select {local _x && {!(_x isKindOf "CAManBase")} && {_x isKindOf "AllVehicles"}});
_entities append GVAR(hitList);
_entities = _entities arrayIntersect _entities;

{
    private _entity = _x;
    private _state = _entity getVariable [QGVAR(state), []];
    private _pos = getPosASL _entity;
    private _index = if (alive _entity) then {GVAR(fields) findIf {[_pos, _x] call FUNC(empInZone)}} else {-1};

    if (_index != -1) then {
        private _entry = GVAR(fields) select _index;
        _entry params ["_anchor", "_cfg", "", "_detTime"];
        if (_state isNotEqualTo [] && {!isNull (_state select 0)}) exitWith {
            [_entity, _cfg, "enforce"] call FUNC(empApply);
        };
        if (_state isNotEqualTo []) then {
            // Hit by a field that is gone: recover first.
            [_entity, _cfg, "restore"] call FUNC(empApply);
        };

        private _due = _entity getVariable [QGVAR(due), []];
        if (_due isEqualTo [] || {(_due select 0) isNotEqualTo _anchor}) then {
            private _speed = _cfg get "shockSpeed";
            private _arrival = _detTime + (if (_speed > 0) then {(_pos distance getPosASL _anchor) / _speed} else {0});
            private _time = if (_now - _arrival < 1.5) then {
                _arrival + (_cfg get "effectDelay")
            } else {
                if (_entity isEqualTo vehicle player || {_entity isEqualTo player}) then {
                    [_cfg get "grace"] call FUNC(empWarnLocal);
                };
                _now + (_cfg get "grace")
            };
            _due = [_anchor, _time];
            _entity setVariable [QGVAR(due), _due];
        };
        if (_now >= (_due select 1)) then {
            _entity setVariable [QGVAR(due), nil];
            _entity setVariable [QGVAR(state), [_anchor]];
            GVAR(hitList) pushBackUnique _entity;
            [_entity, _cfg, "apply"] call FUNC(empApply);
        };
    } else {
        _entity setVariable [QGVAR(due), nil];
        if (_state isEqualTo []) exitWith {
            // Knocked out on another machine before it became local here.
            if (_entity getVariable [QGVAR(dead), false]) then {
                [_entity, createHashMap, "restore"] call FUNC(empApply);
            };
        };
        private _anchor = _state select 0;
        private _found = GVAR(fields) findIf {(_x select 0) isEqualTo _anchor};
        private _cfg = if (_found == -1) then {createHashMap} else {(GVAR(fields) select _found) select 1};
        if (_found == -1 || {_cfg get "restore"} || {!alive _entity}) then {
            [_entity, _cfg, "restore"] call FUNC(empApply);
        } else {
            [_entity, _cfg, "enforce"] call FUNC(empApply);
        };
    };
} forEach _entities;

GVAR(hitList) = GVAR(hitList) select {!isNull _x && {(_x getVariable [QGVAR(state), []]) isNotEqualTo []}};

if (hasInterface) then {
    // UAVs inside a field cannot be controlled from outside either.
    private _uav = getConnectedUAV player;
    if (!isNull _uav && {
        private _uavPos = getPosASL _uav;
        GVAR(fields) findIf {((_x select 1) get "uavs") > 0 && {[_uavPos, _x] call FUNC(empInZone)}} != -1
    }) then {
        player connectTerminalToUAV objNull;
    };
    call FUNC(empAcreSignal);
};

if (GVAR(fields) isEqualTo [] && {GVAR(hitList) isEqualTo []}) then {
    GVAR(loopHandle) = -1;
    _handle call CBA_fnc_removePerFrameHandler;
};
