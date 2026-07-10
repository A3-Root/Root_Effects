#include "script_component.hpp"

if (isServer) then {
    [QGVAR(start), {
        _this call FUNC(floatingStart);
    }] call CBA_fnc_addEventHandler;
};
