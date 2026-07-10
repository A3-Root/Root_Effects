#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Particle timer callback of the big ash clouds. With a small probability it
 * discharges a lightning bolt inside the cloud: a bolt billboard, a short
 * series of local light flashes and a delayed thunder rumble. The engine
 * calls this with _this set to the particle position.
 */

if ((random 10) < 9.9) exitWith {};

private _lightningPos = _this;
private _lightningTexture = selectRandom ["A3\data_f\blesk1", "A3\data_f\blesk2"];

drop [[_lightningTexture, 1, 0, 1], "", "SpaceObject", 1, 0.2, _lightningPos, [0, 0, 0], 0, 10, 7.9, 0, [3], [[1, 1, 1, 1]], [1], 0, 0, "", "", _lightningPos];

private _flashCount = 1 + floor (random 4);
for "_i" from 0 to (_flashCount - 1) do {
    [{
        params ["_lightningPos"];
        private _flashLight = "#lightpoint" createVehicleLocal _lightningPos;
        _flashLight setLightAttenuation [0, 0, 0, 0, 40, 10000];
        _flashLight setLightBrightness (50 + random 150);
        _flashLight setLightDayLight true;
        _flashLight setLightUseFlare false;
        _flashLight setLightFlareSize 50;
        _flashLight setLightFlareMaxDistance 2000;
        _flashLight setLightAmbient [1, 1, 1];
        _flashLight setLightColor [1, 1, 1];

        [{
            params ["_flashLight"];
            deleteVehicle _flashLight;
        }, [_flashLight], 0.15 + random 0.2] call CBA_fnc_waitAndExecute;
    }, [_lightningPos], _i * 0.35] call CBA_fnc_waitAndExecute;
};

[{
    playSound (selectRandom [QGVAR(thunder_1), QGVAR(thunder_2), QGVAR(thunder_3), QGVAR(thunder_4), QGVAR(thunder_5), QGVAR(thunder_6)]);
}, [], _flashCount * 0.35 + 0.5] call CBA_fnc_waitAndExecute;
