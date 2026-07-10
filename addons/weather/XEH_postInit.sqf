#include "script_component.hpp"

if (isServer) then {
    [QGVAR(startLightning), {
        _this call FUNC(lightningStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startAcidRain), {
        _this call FUNC(acidRainStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startMirage), {
        _this call FUNC(mirageStart);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startWaterTint), {
        _this call FUNC(waterTintStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(acidRainLocal), {
        _this call FUNC(acidRainStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(mirageLocal), {
        _this call FUNC(mirageStartLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(waterTintLocal), {
        _this call FUNC(waterTintStartLocal);
    }] call CBA_fnc_addEventHandler;
};
