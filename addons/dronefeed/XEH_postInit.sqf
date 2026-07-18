#include "script_component.hpp"

if (isServer) then {
    // Server side registry of live feeds: feedId -> [anchor, screen, drone, mode].
    GVAR(feeds) = createHashMap;

    [QGVAR(requestCreate), {
        _this call FUNC(serverCreateFeed);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(requestModify), {
        _this call FUNC(serverModifyFeed);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(requestDelete), {
        _this call FUNC(serverDeleteFeed);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(requestKillAll), {
        _this call FUNC(serverKillAll);
    }] call CBA_fnc_addEventHandler;

    // A curator asked for the list of running feeds; answer their machine with a
    // snapshot so the modify or delete dialog can be built from live data.
    [QGVAR(requestFeedList), {
        params [["_purpose", "", [""]], ["_requester", objNull, [objNull]]];
        if (isNull _requester) exitWith {};

        private _data = [];
        {
            _y params ["_anchor", "_screen", "_drone", "_mode"];
            if (!isNull _anchor && {!isNull _screen}) then {
                _data pushBack [_x, netId _screen, _mode, mapGridPosition _screen];
            };
        } forEach GVAR(feeds);

        [QGVAR(showFeedList), [_purpose, _data], [_requester]] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;

    // Prune feeds whose drone died or whose screen vanished.
    [FUNC(serverMonitor), 5, []] call CBA_fnc_addPerFrameHandler;
};

if (hasInterface) then {
    // Client side record of feeds active on this machine: feedId -> state hashmap.
    GVAR(activeFeeds) = createHashMap;
    // Number of feeds the player is currently close enough to render, so the
    // view distance is only saved and restored on the first enter and last exit.
    GVAR(proximityCount) = 0;

    [QGVAR(setupLocal), {
        _this call FUNC(setupFeedLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(showFeedList), {
        params ["_purpose", "_data"];
        switch (_purpose) do {
            case "modify": {
                [_data] call FUNC(dialogModify);
            };
            case "delete": {
                [_data] call FUNC(dialogDelete);
            };
        };
    }] call CBA_fnc_addEventHandler;
};
