#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one comet: a smoke tail and a bright glow light
 * that fades out while the comet streaks across the sky. All objects are
 * local and clean themselves up once the fade completes or the comet body
 * disappears.
 *
 * Arguments:
 * 0: Comet body <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_comet] call root_effects_meteor_fnc_cometLocal
 */

params [["_comet", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _comet) exitWith {};

private _smokeEmitter = "#particlesource" createVehicleLocal getPosATL _comet;
_smokeEmitter setParticleCircle [0, [0, 0, 0]];
_smokeEmitter setParticleRandom [3, [0.25, 0.25, 0.25], [0, 0, 0], 0, 0.25, [0, 0, 0, 0.5], 0, 0];
_smokeEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, 0.75], 30, 10, 7.9, 0, [1.2, 4, 1], [[1, 1, 1, 1], [0.25, 0.25, 0.25, 0.5]], [0.08], 1, 0, "", "", _comet];
_smokeEmitter setDropInterval (0.002 / ((EGVAR(main,particleBudget)) max 0.1));

private _cometLight = "#lightpoint" createVehicleLocal getPos _comet;
_cometLight lightAttachObject [_comet, [0, 0, 0]];
_cometLight setLightIntensity 3000;
_cometLight setLightAttenuation [500, 300, 3000, 0, 5, 500];
_cometLight setLightUseFlare true;
_cometLight setLightFlareSize 10;
_cometLight setLightFlareMaxDistance 2000;
_cometLight setLightAmbient [1, 0.8, 0.7];
_cometLight setLightColor [1, 1, 1];

[{
    params ["_cometLight"];
    if (!isNull _cometLight) then {
        _cometLight setLightFlareSize 5;
    };
}, [_cometLight], 0.2] call CBA_fnc_waitAndExecute;

// Fade the glow out over about three seconds, then clean everything up.
// [comet, light, smoke, brightness]
[{
    params ["_args", "_handle"];
    _args params ["_comet", "_cometLight", "_smokeEmitter", "_brightness"];

    _brightness = _brightness - 50;
    _args set [3, _brightness];

    if (_brightness <= 0 || {isNull _comet}) exitWith {
        deleteVehicle _cometLight;
        deleteVehicle _smokeEmitter;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    _cometLight setLightIntensity _brightness;
}, 0.05, [_comet, _cometLight, _smokeEmitter, 3000]] call CBA_fnc_addPerFrameHandler;
