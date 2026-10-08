#include "..\script_component.hpp"

/*
 * Author: Root
 * Writes one debug line when debug output is enabled in the CBA settings.
 * Usually invoked through the DBG macro. Every line says what happened, in which
 * component, on which machine (server, headless client or client and its owner
 * id), when (mission time) and as whom (the local player, if any):
 *   [Root's Effects][volcano][SERVER t=123.4] avalanche started at 123456 ...
 * Output levels: 0 off, 1 RPT only, 2 RPT plus system chat for Zeus users and
 * admins. At level 2 lines from the server and headless clients are relayed to
 * every curator so nothing that happens remotely goes unseen.
 *
 * Arguments:
 * 0: Component name <STRING>
 * 1: Message <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["volcano", "eruption scheduled"] call root_effects_main_fnc_log
 */

params [["_component", "", [""]], ["_message", "", [""]]];

private _level = missionNamespace getVariable [QGVAR(debugOutput), 1];
if (_level isEqualType true) then {_level = parseNumber _level};
if (_level <= 0) exitWith {};

private _machine = switch (true) do {
    case (isServer && hasInterface): {"HOST"};
    case (isServer): {"SERVER"};
    case (!hasInterface): {format ["HC#%1", clientOwner]};
    default {format ["CLIENT#%1", clientOwner]};
};
private _who = ["", format [" %1", profileName]] select hasInterface;
private _line = format ["[Root's Effects][%1][%2%3 t=%4] %5", _component, _machine, _who, CBA_missionTime toFixed 1, _message];

diag_log text _line;

if (_level < 2) exitWith {};

// Zeus users and admins also get it in chat.
if (hasInterface && {!isNull getAssignedCuratorLogic player || {serverCommandAvailable "#kick"}}) then {
    systemChat _line;
};

// Lines from machines nobody is looking at go to every curator.
if (!hasInterface || {isServer}) then {
    private _curators = (allCurators apply {getAssignedCuratorUnit _x}) select {!isNull _x && {_x != player}};
    if (_curators isNotEqualTo []) then {
        [QGVAR(logRelay), [_line], _curators] call CBA_fnc_targetEvent;
    };
};
