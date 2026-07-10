#include "script_component.hpp"

if (isServer) then {
    [QGVAR(start), {
        _this call FUNC(fireworksStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(startLocal), {
        _this call FUNC(fireworksStartLocal);
    }] call CBA_fnc_addEventHandler;
};
