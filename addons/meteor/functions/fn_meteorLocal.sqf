#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one falling meteor: entry boom, glow light, smoke
 * and spark trail plus the recurring whistle while the meteor falls. All
 * objects are local and clean themselves up when the meteor body disappears.
 *
 * Arguments:
 * 0: Meteor body <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_meteor] call root_effects_meteor_fnc_meteorLocal
 */

params [["_meteor", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _meteor) exitWith {};

_meteor say3D [selectRandom [QGVAR(entry_1), QGVAR(entry_2), QGVAR(entry_3), QGVAR(entry_4), QGVAR(entry_5)], 4000];

// Occasional bright sky flash announcing the meteor.
if (random 30 < 7) then {
    private _flashLight = "#lightpoint" createVehicleLocal getPos _meteor;
    _flashLight setLightDayLight true;
    _flashLight setLightBrightness 30000;
    _flashLight setLightAmbient [0.5, 0.5, 1];
    _flashLight setLightColor [1, 1, random 2];

    [{
        params ["_flashLight"];
        deleteVehicle _flashLight;
    }, [_flashLight], 0.5] call CBA_fnc_waitAndExecute;
};

private _trailLight = "#lightpoint" createVehicleLocal getPos _meteor;
_trailLight setLightBrightness 90;
_trailLight setLightDayLight true;
_trailLight setLightAmbient [1, 0.5, 0];
_trailLight setLightColor [1, 0.5, 0];
_trailLight lightAttachObject [_meteor, [0, 0, 0.1]];

private _budget = (EGVAR(main,particleBudget)) max 0.1;

private _smokeEmitter = "#particlesource" createVehicleLocal getPosATL _meteor;
_smokeEmitter setParticleCircle [0, [0, 0, 0]];
_smokeEmitter setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_smokeEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 3, 17, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0.5], 5, 10.1, 7.9, 0.0001, [7, 3, 1], [[0.1, 0.1, 0.1, 0.9], [0.6, 0.6, 0.6, 0.6], [0.8, 0.8, 0.8, 0.4], [0.9, 0.9, 0.9, 0.3], [1, 1, 1, 0.1]], [500], 1, 0, "", "", _meteor];
_smokeEmitter setDropInterval (0.002 / _budget);

private _sparkEmitter = "#particlesource" createVehicleLocal getPosATL _meteor;
_sparkEmitter setParticleCircle [0, [0, 0, 0]];
_sparkEmitter setParticleRandom [0.5, [1, 1, 0], [0.175, 0.175, 0], 5, 0.25, [0, 0, 0, 0.5], 1, 0];
_sparkEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 7, [0, 0, 3], [0, 0, 0], 7, 10, 7.9, 0.1, [10, 20, 50], [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _meteor];
_sparkEmitter setDropInterval (0.01 / _budget);

// Whistle while falling; everything is torn down once the body is gone.
[{
    params ["_args", "_handle"];
    _args params ["_meteor", "_trailLight", "_smokeEmitter", "_sparkEmitter"];

    if (isNull _meteor) exitWith {
        deleteVehicle _trailLight;
        deleteVehicle _smokeEmitter;
        deleteVehicle _sparkEmitter;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    _meteor say3D [QGVAR(whistle), 2000];
}, 0.9, [_meteor, _trailLight, _smokeEmitter, _sparkEmitter]] call CBA_fnc_addPerFrameHandler;
