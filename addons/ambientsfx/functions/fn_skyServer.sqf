#include "..\script_component.hpp"

/*
 * Author: Root
 * Server side control of a running aurora or spacetime rupture. Publishes the
 * live sky settings on the anchor that every client renderer reads each tick,
 * re-rolls the shape on the shape switch timer, and moves the anchor when a
 * movement speed is set (drifting along one heading, or wandering around where it
 * started). Called once by the start functions; the Modify Sky Effect module
 * changes the same anchor variables later.
 *
 * Live settings, QGVAR(skyCfg): [new particles, fade out, size scale, length scale, shape id, seed]
 * Control, QGVAR(skyCtl): [shape switch seconds (0 off), chosen shape (5 random), move speed m/s, move mode (0 drift, 1 wander)]
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Live settings <ARRAY>
 * 2: Control settings <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, [true, true, 1, 1, 0, 1234], [0, 0, 0, 0]] call root_effects_ambientsfx_fnc_skyServer
 */

params [["_anchor", objNull, [objNull]], ["_cfg", [], [[]]], ["_ctl", [], [[]]]];

if (!isServer || {isNull _anchor}) exitWith {};

_anchor setVariable [QGVAR(skyCfg), _cfg, true];
_anchor setVariable [QGVAR(skyCtl), _ctl, true];
_anchor setVariable [QGVAR(skyHome), getPosATL _anchor];

private _key = _anchor getVariable [QEGVAR(main,effectKey), "sky"];
DBG(FORMAT_3("%1 control: settings %2, control %3",_key,_cfg,_ctl));

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_nextSwitch", "_heading"];

    if (isNull _anchor) exitWith {_handle call CBA_fnc_removePerFrameHandler};

    (_anchor getVariable [QGVAR(skyCtl), [0, 0, 0, 0]]) params [["_switch", 0], ["_chosen", 0], ["_speed", 0], ["_mode", 0]];

    // Shape switch: a fresh seed (and a fresh shape when the shape is random).
    if (_switch > 0) then {
        if (_nextSwitch < 0) exitWith {_args set [1, CBA_missionTime + _switch]};
        if (CBA_missionTime >= _nextSwitch) then {
            private _cfg = +(_anchor getVariable [QGVAR(skyCfg), [true, true, 1, 1, 0, 0]]);
            _cfg set [4, [_chosen, floor random 5] select (_chosen == 5)];
            _cfg set [5, floor random 1e6];
            _anchor setVariable [QGVAR(skyCfg), _cfg, true];
            _args set [1, CBA_missionTime + _switch];
            DBG(FORMAT_2("sky shape switched to %1 (seed %2)",_cfg select 4,_cfg select 5));
        };
    } else {
        _args set [1, -1];
    };

    // Movement, applied every half second.
    if (_speed > 0) then {
        private _pos = getPosATL _anchor;
        if (_mode == 1) then {
            // Wander: drift with a slowly turning heading, pulled back home when it strays.
            private _home = _anchor getVariable [QGVAR(skyHome), _pos];
            _heading = _heading + (random 30 - 15);
            if ((_pos distance2D _home) > 1500) then {_heading = _pos getDir _home};
            _args set [2, _heading];
        };
        private _next = _pos getPos [_speed * 0.5, _heading];
        _next set [2, _pos select 2];
        _anchor setPosATL _next;
    };
}, 0.5, [_anchor, -1, random 360]] call CBA_fnc_addPerFrameHandler;
