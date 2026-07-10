#include "..\script_component.hpp"

/*
 * Author: Root, based on work by johnb43
 * Applies or removes an animation based freeze on the machine where the unit
 * is local, so the animation change is authoritative and replicates.
 *
 * Arguments:
 * 0: Unit to affect <OBJECT>
 * 1: Freeze (true) or unfreeze (false) <BOOL>
 * 2: Animation name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, true, "HubSpectator_stand"] call root_effects_freeze_fnc_freezeLocal
 */

params [["_unit", objNull, [objNull]], ["_freeze", true, [false]], ["_animation", "HubSpectator_stand", [""]]];

if (isNull _unit || {!local _unit}) exitWith {};

if (_freeze) then {
    _unit playMove _animation;
} else {
    _unit switchMove "";
};
