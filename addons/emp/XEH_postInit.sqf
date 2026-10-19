#include "script_component.hpp"

if (isServer) then {
    [QGVAR(start), {
        _this call FUNC(empStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(create), {
        _this call FUNC(create);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(disable), {
        _this call FUNC(disable);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(modify), {
        _this call FUNC(modify);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(sparks), {
        _this call FUNC(empSparksLocal);
    }] call CBA_fnc_addEventHandler;
};

// Every machine tracks the fields for the units and vehicles local to it.
[QGVAR(fieldLocal), {
    _this call FUNC(empFieldLocal);
}] call CBA_fnc_addEventHandler;
