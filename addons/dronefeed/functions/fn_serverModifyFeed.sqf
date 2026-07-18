#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies changes to a running feed on the server by writing the new values to
 * the screen's public variables, which every client's tracking loop reads. Each
 * field carries an explicit value or a "no change" sentinel so the modify
 * dialog never toggles a setting by accident.
 *
 * Arguments (single array):
 * 0: Feed id <STRING>
 * 1: New view, "" for no change <STRING>
 * 2: New vision mode, -1 for no change <NUMBER>
 * 3: New render mode, "" for no change <STRING>
 * 4: New radius, 0 for no change <NUMBER>
 * 5: New drone netId, "" for no change <STRING>
 * 6: New controller netId, "" for no change, "CLEAR" to release <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["df_12_345", "DRIVER", -1, "", 0, "", ""]] call root_effects_dronefeed_fnc_serverModifyFeed
 */

params [["_args", [], [[]]]];
_args params [
    ["_feedId", "", [""]],
    ["_view", "", [""]],
    ["_vision", -1, [0]],
    ["_renderMode", "", [""]],
    ["_radius", 0, [0]],
    ["_droneNetId", "", [""]],
    ["_controllerNetId", "", [""]]
];

if (!isServer) exitWith {};

private _entry = GVAR(feeds) getOrDefault [_feedId, []];
if (_entry isEqualTo []) exitWith {};
_entry params ["_anchor", "_screen", "_drone", "_mode"];
if (isNull _screen) exitWith {};

if (_view isNotEqualTo "") then {
    _screen setVariable [QGVAR(view), _view, true];
};
if (_vision >= 0) then {
    _screen setVariable [QGVAR(vision), _vision, true];
};
if (_renderMode isNotEqualTo "") then {
    _screen setVariable [QGVAR(renderMode), _renderMode, true];
};
if (_radius > 0) then {
    _screen setVariable [QGVAR(radius), _radius, true];
};
if (_droneNetId isNotEqualTo "") then {
    private _newDrone = objectFromNetId _droneNetId;
    if (!isNull _newDrone) then {
        _screen setVariable [QGVAR(droneNetId), _droneNetId, true];
        GVAR(feeds) set [_feedId, [_anchor, _screen, _newDrone, _mode]];
    };
};
if (_controllerNetId isEqualTo "CLEAR") then {
    _screen setVariable [QGVAR(controller), objNull, true];
} else {
    if (_controllerNetId isNotEqualTo "") then {
        _screen setVariable [QGVAR(controller), objectFromNetId _controllerNetId, true];
    };
};

DBG(FORMAT_1("drone feed %1 modified",_feedId));
