#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startMap), {
        _this call FUNC(briefingMapStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startTable), {
        _this call FUNC(briefingTableStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(mapLocal), {
        _this call FUNC(briefingMapStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(tableLocal), {
        _this call FUNC(briefingTableStartLocal);
    }] call CBA_fnc_addEventHandler;
};
