#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startAAA), {
        _this call FUNC(aaaStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startArtillery), {
        _this call FUNC(artilleryStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startMissiles), {
        _this call FUNC(missilesStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startSearchlight), {
        _this call FUNC(searchlightStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startTracers), {
        _this call FUNC(tracersStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(aaaLocal), {
        _this call FUNC(aaaStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(aaaBurst), {
        _this call FUNC(aaaBurstLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(artilleryImpact), {
        _this call FUNC(artilleryImpactLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(missileLaunch), {
        _this call FUNC(missileLaunchLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(searchlightLocal), {
        _this call FUNC(searchlightStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(tracersLocal), {
        _this call FUNC(tracersStartLocal);
    }] call CBA_fnc_addEventHandler;
};
