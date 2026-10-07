#include "script_component.hpp"

if (isServer) then {
    [QGVAR(start), {
        _this call FUNC(volcanoStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startAvalanche), {
        _this call FUNC(avalancheStart);
    }] call CBA_fnc_addEventHandler;
};

// Rock shoves a vehicle downhill; velocity only takes on the owning machine.
[QGVAR(avalanchePush), {
    params ["_object", "_push"];
    if (isNull _object || {!alive _object}) exitWith {};
    _object setVelocity ((velocity _object) vectorAdd _push);
}] call CBA_fnc_addEventHandler;

if (hasInterface) then {
    [QGVAR(startLocal), {
        _this call FUNC(volcanoStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(burst), {
        _this call FUNC(volcanoBurstLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(avalancheLocal), {
        _this call FUNC(avalancheLocal);
    }] call CBA_fnc_addEventHandler;
};
