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
        _this call FUNC(meteorLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(meteorImpact), {
        _this call FUNC(meteorImpactLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(cometLocal), {
        _this call FUNC(cometLocal);
    }] call CBA_fnc_addEventHandler;
};
