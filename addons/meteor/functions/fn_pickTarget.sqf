#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Picks a random living player (or switchable unit in singleplayer) as the
 * reference position for the next meteor or comet spawn. Falls back to the
 * given position when nobody qualifies.
 *
 * Arguments:
 * 0: Fallback position <ARRAY>
 *
 * Return Value:
 * Reference position <ARRAY>
 *
 * Example:
 * [[1000, 2000, 0]] call root_effects_meteor_fnc_pickTarget
 */

params [["_fallback", [0, 0, 0], [[]], 3]];

private _candidates = (call CBA_fnc_players) select {alive _x && {!(_x isKindOf "VirtualMan_F")}};

if (_candidates isEqualTo []) exitWith {_fallback};

getPos (selectRandom _candidates)
