#include "..\script_component.hpp"

/*
 * Author: Root
 * Sends a Zeus module request to the server like CBA_fnc_serverEvent, and logs
 * who asked for what, where. Every Zeus module goes through this, so with debug
 * output on each module use shows up with the curator's name, the map grid of
 * the first position in the request and the full request.
 *
 * Arguments:
 * 0: Event name <STRING>
 * 1: Event arguments <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [QGVAR(startVolcano), [_pos, 50]] call root_effects_main_fnc_serverEventLogged
 */

params [["_event", "", [""]], ["_args", []]];

private _where = "";
if (_args isEqualType []) then {
    private _pos = _args findIf {_x isEqualType [] && {count _x in [2, 3]} && {(_x select 0) isEqualType 0}};
    if (_pos != -1) then {
        _where = format [" at %1", mapGridPosition (_args select _pos)];
    } else {
        private _obj = _args findIf {_x isEqualType objNull && {!isNull _x}};
        if (_obj != -1) then {_where = format [" at %1 (%2)", mapGridPosition (_args select _obj), typeOf (_args select _obj)]};
    };
};

["zeus", format ["%1 requested %2%3 with %4", profileName, _event, _where, _args]] call FUNC(log);

[_event, _args] call CBA_fnc_serverEvent;
