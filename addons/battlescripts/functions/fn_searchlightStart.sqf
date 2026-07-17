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
 * 2: Mount the beam on the nearest vehicle or static weapon <BOOL>
 * 3: Sweep automatically while the mount has no gunner <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], false, false, true] call root_effects_battlescripts_fnc_searchlightStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_alarm", false, [false]],
    ["_attach", false, [false]],
    ["_aiSearch", true, [false]]
];

if (!isServer) exitWith {};
if (!(["searchlight"] call EFUNC(main,isEffectEnabled))) exitWith {};

// The mount is resolved once here and shipped to the clients, so every machine
// animates the beam against the same object.
// Effect anchors are invisible helipads and would otherwise win the search.
private _attachTo = objNull;
if (_attach) then {
    _attachTo = ((nearestObjects [_pos, ["AllVehicles", "Static"], 8]) select {(typeOf _x) isNotEqualTo ANCHOR_CLASS}) param [0, objNull];
};

private _anchor = ["searchlight", QGVAR(searchlightLocal), [_alarm, _attachTo, _aiSearch], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

DBG(FORMAT_2("searchlight started, alarm %1, mounted on %2",_alarm,typeOf _attachTo));
