#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies Modify Sky Effect settings to a running aurora or spacetime rupture on
 * the server. Keep As Is holds every particle exactly where it is: nothing new is
 * added and nothing fades. Otherwise new particles and fading out can each be
 * switched on or off. Size, length, shape, shape switching and movement change
 * live; nothing restarts.
 *
 * Arguments:
 * 0: Sky effect anchor <OBJECT>
 * 1: Keep as is <BOOL>
 * 2: Allow new particles <BOOL>
 * 3: Allow particles to fade out <BOOL>
 * 4: Size scale <NUMBER>
 * 5: Length scale <NUMBER>
 * 6: Shape 0 band, 1 arc, 2 wave, 3 ring, 4 spiral, 5 random, 6 unchanged <NUMBER>
 * 7: Shape switch interval in seconds, 0 never <NUMBER>
 * 8: Movement speed m/s <NUMBER>
 * 9: Movement mode 0 drift, 1 wander <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, true, false, false, 1, 1, 6, 0, 0, 0] call root_effects_ambientsfx_fnc_skyModify
 */

params [
    ["_anchor", objNull, [objNull]],
    ["_freeze", false, [false]],
    ["_spawn", true, [false]],
    ["_despawn", true, [false]],
    ["_sizeScale", 1, [0]],
    ["_lengthScale", 1, [0]],
    ["_shape", -1, [0]],
    ["_switchInterval", 0, [0]],
    ["_moveSpeed", 0, [0]],
    ["_moveMode", 0, [0]]
];

DBG(FORMAT_1("skyModify called with %1",_this));

if (!isServer || {isNull _anchor}) exitWith {};

if (_freeze) then {
    _spawn = false;
    _despawn = false;
};

private _cfg = +(_anchor getVariable [QGVAR(skyCfg), [true, true, 1, 1, 0, 0]]);
private _ctl = +(_anchor getVariable [QGVAR(skyCtl), [0, 0, 0, 0]]);

_cfg set [0, _spawn];
_cfg set [1, _despawn];
_cfg set [2, (_sizeScale max 0.2) min 5];
_cfg set [3, (_lengthScale max 0.2) min 5];
if (_shape in [0, 1, 2, 3, 4, 5] && {_shape != (_ctl select 1)}) then {
    _cfg set [4, _shape];
    _cfg set [5, floor random 1e6];
    _ctl set [1, _shape];
};
_ctl set [0, _switchInterval max 0];
_ctl set [2, (_moveSpeed max 0) min 100];
_ctl set [3, _moveMode];

_anchor setVariable [QGVAR(skyCfg), _cfg, true];
_anchor setVariable [QGVAR(skyCtl), _ctl, true];

private _key = _anchor getVariable [QEGVAR(main,effectKey), "sky"];
DBG(FORMAT_4("%1 at %2 modified: settings %3, control %4",_key,mapGridPosition _anchor,_cfg,_ctl));
