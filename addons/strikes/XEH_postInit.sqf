#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startLaser), {
        _this call FUNC(laserStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startNapalm), {
        _this call FUNC(napalmStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startCarpet), {
        _this call FUNC(carpetStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(laserLocal), {
        _this call FUNC(laserLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(napalmLocal), {
        _this call FUNC(napalmStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(carpetSound), {
        _this call FUNC(carpetSoundLocal);
    }] call CBA_fnc_addEventHandler;
};
