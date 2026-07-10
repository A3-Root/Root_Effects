#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Renders one ambient rocket launch on this client: a local rocket body
 * shooting skyward with an attached glow light, exhaust smoke and launch
 * sound. Skipped while the player is inside the minimum safe distance or too
 * far away to see it. Everything is local and deleted after the flight.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Minimum player distance before rockets are shown <NUMBER>
 * 2: Delay between launches, reused as flight lifetime <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 25, 10] call root_effects_battlescripts_fnc_missileLaunchLocal
 */

params [["_anchor", objNull, [objNull]], ["_safeDistance", 25, [0]], ["_launchDelay", 10, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

private _distance = player distance _anchor;
if (_distance <= _safeDistance) exitWith {};
if (_distance > EGVAR(main,maxViewDistance)) exitWith {};

private _pos = getPosATL _anchor;
private _rocket = "Land_Battery_F" createVehicleLocal _pos;
_rocket setPosATL _pos;

private _rocketLight = "#lightpoint" createVehicleLocal _pos;
_rocketLight setLightBrightness 100;
_rocketLight setLightAttenuation [5, 0, 100, 2000, 200, 500];
_rocketLight setLightUseFlare true;
_rocketLight setLightFlareSize 1;
_rocketLight setLightFlareMaxDistance 2000;
_rocketLight setLightAmbient [1, 0.7, 0];
_rocketLight setLightColor [1, 1, 1];
_rocketLight lightAttachObject [_rocket, [0, 0, -3]];

_rocket say3D [selectRandom [QGVAR(missile_launch_1), QGVAR(missile_launch_2), QGVAR(missile_launch_3), QGVAR(missile_launch_4)], 2000];

private _smokeEmitter = "#particlesource" createVehicleLocal _pos;
_smokeEmitter setParticleCircle [0, [0, 0, 0]];
_smokeEmitter setParticleRandom [2, [0, 0, 0], [0.2, 0.2, 0.5], 0.3, 0.5, [0, 0, 0, 0.5], 0, 0];
_smokeEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2 + random 1, [0, 0, 0], [0, 0, 1], 3, 0.01, 0.007, 0, [4, 1, 7, 10], [[1, 1, 1, 1], [0.6, 0.3, 0.2, 1], [0, 0, 0, 0.5], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _rocket];
_smokeEmitter setDropInterval (0.002 / ((EGVAR(main,particleBudget)) max 0.1));

_rocket setVelocity [0, 0, 200];

[{
    params ["_rocket", "_rocketLight", "_smokeEmitter"];
    deleteVehicle _smokeEmitter;
    deleteVehicle _rocketLight;
    deleteVehicle _rocket;
}, [_rocket, _rocketLight, _smokeEmitter], (_launchDelay min 10) max 3] call CBA_fnc_waitAndExecute;
