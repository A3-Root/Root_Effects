#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startMap), {
        _this call FUNC(briefingMapStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startTable), {
        _this call FUNC(briefingTableStart);
    }] call CBA_fnc_addEventHandler;

    // Exclusive briefing map ownership is resolved on the server so two players
    // cannot grab the same board at once.
    [QGVAR(requestControl), {
        params ["_anchor", "_player"];
        if (isNull _anchor || {!alive _player}) exitWith {};
        private _current = _anchor getVariable [QGVAR(controller), objNull];
        if (isNull _current || {!alive _current}) then {
            _anchor setVariable [QGVAR(controller), _player, true];
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(releaseControl), {
        params ["_anchor", "_player"];
        if (isNull _anchor) exitWith {};
        if ((_anchor getVariable [QGVAR(controller), objNull]) isEqualTo _player) then {
            _anchor setVariable [QGVAR(controller), objNull, true];
        };
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(mapLocal), {
        _this call FUNC(briefingMapStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(tableLocal), {
        _this call FUNC(briefingTableStartLocal);
    }] call CBA_fnc_addEventHandler;

    // While this player owns a briefing map, clicking their own map sets the
    // area that board shows for everyone. The owned board is tracked in
    // uiNamespace so a single handler serves whichever map is under control.
    addMissionEventHandler ["MapSingleClick", {
        params ["", "_clickPos"];
        private _anchor = uiNamespace getVariable [QGVAR(controlledAnchor), objNull];
        if (!isNull _anchor) then {
            _anchor setVariable [QGVAR(feedCenter), _clickPos, true];
        };
    }];
};
