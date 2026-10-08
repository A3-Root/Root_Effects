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

// The tornado throws an object on the machine that owns it.
// Tornado wind on an object, on the machine that owns it: slowed down, then shoved.
[QGVAR(tornadoWind), {
    params ["_object", "_push", ["_damping", 1]];
    if (isNull _object) exitWith {};
    _object setVelocity (((velocity _object) vectorMultiply _damping) vectorAdd _push);
}] call CBA_fnc_addEventHandler;

[QGVAR(tornadoFling), {
    params ["_object", "_velocity"];
    if (isNull _object) exitWith {};
    _object setVelocity ((velocity _object) vectorAdd _velocity);
}] call CBA_fnc_addEventHandler;

if (hasInterface) then {
    [QGVAR(tornadoLocal), {
        _this call FUNC(tornadoLocal);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(lightningStrike), {
        _this call FUNC(lightningStrikeLocal);
    }] call CBA_fnc_addEventHandler;

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
