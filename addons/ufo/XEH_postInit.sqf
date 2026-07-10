#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startEncounter), {
        _this call FUNC(encounterStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startSeeker), {
        _this call FUNC(seekerStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startCropCircle), {
        _this call FUNC(cropCircleStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(crossLocal), {
        _this call FUNC(crossLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(jumpLocal), {
        _this call FUNC(jumpLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(seekerLocal), {
        _this call FUNC(seekerLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(cropCircleLocal), {
        _this call FUNC(cropCircleLocal);
    }] call CBA_fnc_addEventHandler;
};
