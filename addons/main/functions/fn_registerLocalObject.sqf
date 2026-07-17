#include "..\script_component.hpp"

/*
 * Author: Root
 * Records a persistent local prop an effect has left in the world (a crater,
 * decal or other simple object) against the netId of its instance anchor, so
 * the termination module can delete these otherwise fire-and-forget objects
 * when the instance is stopped. Runs on the machine that owns the local object.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Local object to track <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, _crater] call root_effects_main_fnc_registerLocalObject
 */

params [["_anchor", objNull, [objNull]], ["_object", objNull, [objNull]]];

if (isNull _anchor || {isNull _object}) exitWith {};

private _key = netId _anchor;
private _list = GVAR(localObjects) getOrDefault [_key, []];
_list pushBack _object;
GVAR(localObjects) set [_key, _list];
