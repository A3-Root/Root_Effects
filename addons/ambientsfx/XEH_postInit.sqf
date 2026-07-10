#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startFireflies), {
        _this call FUNC(firefliesStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startAurora), {
        _this call FUNC(auroraStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startRupture), {
        _this call FUNC(ruptureStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startSparks), {
        _this call FUNC(sparksStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startBirdSwarm), {
        _this call FUNC(birdSwarmStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(firefliesLocal), {
        _this call FUNC(firefliesStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(auroraLocal), {
        _this call FUNC(auroraStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(ruptureLocal), {
        _this call FUNC(ruptureStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(sparkBurst), {
        _this call FUNC(sparkBurstLocal);
    }] call CBA_fnc_addEventHandler;
};
