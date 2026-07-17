#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Picks the reference position for the next meteor or comet spawn, following
 * the target mode chosen in the module. Every mode falls back to the given
 * position when nothing qualifies, so the effect never stalls.
 *
 * Arguments:
 * 0: Fallback position <ARRAY>
 * 1: Target mode, 0 random players / 1 module area / 2 specific owners <NUMBER>
 * 2: Area radius in meters, mode 1 only <NUMBER>
 * 3: Owners to target [sides, groups, players, tab], mode 2 only <ARRAY>
 *
 * Return Value:
 * Reference position <ARRAY>
 *
 * Example:
 * [[1000, 2000, 0], 1, 300, []] call root_effects_meteor_fnc_pickTarget
 */

params [["_fallback", [0, 0, 0], [[]], 3], ["_mode", 0, [0]], ["_radius", 300, [0]], ["_owners", [], [[]]]];

private _fnc_livingPlayers = {
    (call CBA_fnc_players) select {alive _x && {!(_x isKindOf "VirtualMan_F")}}
};

switch (round _mode) do {
    case 1: {
        // Scatter anywhere inside the module area, ignoring where players are.
        _fallback getPos [random _radius, random 360]
    };
    case 2: {
        _owners params [["_sides", [], [[]]], ["_groups", [], [[]]], ["_players", [], [[]]]];

        private _candidates = ([] call _fnc_livingPlayers) select {
            (side (group _x)) in _sides || {(group _x) in _groups} || {_x in _players}
        };

        // Nobody from the selection is around; fall back to any player, then
        // to the module position, rather than dropping the strike.
        if (_candidates isEqualTo []) then {
            _candidates = [] call _fnc_livingPlayers;
        };
        if (_candidates isEqualTo []) exitWith {_fallback};

        getPos (selectRandom _candidates)
    };
    default {
        private _candidates = [] call _fnc_livingPlayers;
        if (_candidates isEqualTo []) exitWith {_fallback};

        getPos (selectRandom _candidates)
    };
};
