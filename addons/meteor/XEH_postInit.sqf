#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startMeteors), {
        _this call FUNC(meteorsStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startComets), {
        _this call FUNC(cometsStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(meteorLocal), {
        // Object created in the same frame may arrive after the event.
        params ["_netId"];
        [{!isNull objectFromNetId _this}, {
            [objectFromNetId _this] call FUNC(meteorLocal);
        }, _netId, 5] call CBA_fnc_waitUntilAndExecute;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(meteorImpact), {
        _this call FUNC(meteorImpactLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(cometLocal), {
        // Object created in the same frame may arrive after the event.
        params ["_netId"];
        [{!isNull objectFromNetId _this}, {
            [objectFromNetId _this] call FUNC(cometLocal);
        }, _netId, 5] call CBA_fnc_waitUntilAndExecute;
    }] call CBA_fnc_addEventHandler;
};
