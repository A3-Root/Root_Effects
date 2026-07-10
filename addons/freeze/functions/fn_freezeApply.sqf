#include "..\script_component.hpp"

/*
 * Author: Root, based on work by johnb43
 * Applies or removes the freeze state for a list of units on the server.
 * Simulation freezing uses the global simulation toggle directly; animation
 * freezing is forwarded to the machine where each unit is local.
 *
 * Arguments:
 * 0: Units to affect <ARRAY>
 * 1: Freeze (true) or unfreeze (false) <BOOL>
 * 2: Freeze with a looping animation instead of stopping simulation <BOOL>
 * 3: Animation name for animation based freezing <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_unit], true, false, ""] call root_effects_freeze_fnc_freezeApply
 */

params [["_targets", [], [[]]], ["_freeze", true, [false]], ["_useAnim", false, [false]], ["_animation", "HubSpectator_stand", [""]]];

if (!isServer) exitWith {};
if (!(["freeze"] call EFUNC(main,isEffectEnabled))) exitWith {};

{
    private _unit = _x;
    if (!isNull _unit && {alive _unit}) then {
        if (_useAnim) then {
            [QGVAR(applyLocal), [_unit, _freeze, _animation], [_unit]] call CBA_fnc_targetEvent;
        } else {
            _unit enableSimulationGlobal !_freeze;

            if (!_freeze) then {
                // Refresh AI knowledge about the unit after it thaws.
                {
                    _x reveal _unit;
                } forEach allUnits;
            };
        };
    };
} forEach _targets;

DBG(FORMAT_2("freeze state %1 applied to %2 units",_freeze,count _targets));
