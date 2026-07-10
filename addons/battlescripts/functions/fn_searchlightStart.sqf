#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts a sweeping searchlight on the server: creates the anchor and
 * broadcasts the setup to all clients (JIP safe). The light volume itself is
 * created and animated locally on every client, so no position updates cross
 * the network.
 *
 * Arguments:
 * 0: Position ATL of the searchlight <ARRAY>
 * 1: Play a recurring air raid alarm <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], false] call root_effects_battlescripts_fnc_searchlightStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_alarm", false, [false]]
];

if (!isServer) exitWith {};
if (!(["searchlight"] call EFUNC(main,isEffectEnabled))) exitWith {};

private _anchor = ["searchlight", QGVAR(searchlightLocal), [_alarm], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_1("searchlight started, alarm %1",_alarm));
