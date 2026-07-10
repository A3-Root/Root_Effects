#include "script_component.hpp"

if (isServer) then {
    [QGVAR(start), {
        _this call FUNC(empStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(pulseLocal), {
        _this call FUNC(empLocal);
    }] call CBA_fnc_addEventHandler;
};

// Vehicle state changes have to run where the vehicle is local.
[QGVAR(vehicleLocal), {
    _this call FUNC(empVehicleLocal);
}] call CBA_fnc_addEventHandler;
