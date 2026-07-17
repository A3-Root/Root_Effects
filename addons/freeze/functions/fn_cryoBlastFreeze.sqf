#include "..\script_component.hpp"

/*
 * Author: Root
 * Locks or releases the units caught in a cryogenic blast on the server.
 * Kept separate from the curator freeze: that one suspends players on demand,
 * this one is the ice itself, so the two are gated and toggled independently.
 *
 * Arguments:
 * 0: Units to affect <ARRAY>
 * 1: Freeze (true) or thaw (false) <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_unit], true] call root_effects_freeze_fnc_cryoBlastFreeze
 */

params [["_targets", [], [[]]], ["_freeze", true, [false]]];

if (!isServer) exitWith {};
if (!(["cryoblast"] call EFUNC(main,isEffectEnabled))) exitWith {};

{
    private _unit = _x;
    if (!isNull _unit && {alive _unit}) then {
        _unit enableSimulationGlobal !_freeze;

        if (!_freeze) then {
            // Refresh AI knowledge about the unit after it thaws.
            {
                _x reveal _unit;
            } forEach allUnits;
        };
    };
} forEach _targets;

DBG(FORMAT_2("cryo freeze state %1 applied to %2 units",_freeze,count _targets));
