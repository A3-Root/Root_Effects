#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one meteor impact: hot splash, rock spray, dust
 * shockwave, smoke, crater, glow light, a distance delayed explosion sound
 * and camera shake. Everything is local and cleans itself up within seconds.
 *
 * Arguments:
 * 0: Impact position <ARRAY>
 * 1: Horizontal velocity X of the meteor <NUMBER>
 * 2: Horizontal velocity Y of the meteor <NUMBER>
 * 3: Show the dust shockwave ring <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 5, 5, true] call root_effects_meteor_fnc_meteorImpactLocal
 */

params [["_impactPos", [0, 0, 0], [[]], 3], ["_velocityX", 0, [0]], ["_velocityY", 0, [0]], ["_shockwave", true, [false]]];

if (!hasInterface) exitWith {};
if ((player distance2D _impactPos) > ((EGVAR(main,maxViewDistance)) max 2000)) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;

private _splashHot = "#particlesource" createVehicleLocal _impactPos;
_splashHot setParticleCircle [0, [0, 0, 0]];
_splashHot setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 0, 16, 1], "", "Billboard", 1, 0.3, [0, 0, 0], [0, 0, 0], 5, 10, 7, 0.1, [80, 60], [[1, 1, 1, 1], [1, 1, 1, 0]], [1], 1, 0, "", "", _impactPos];
_splashHot setDropInterval 0.1;

private _rockEmitter = "#particlesource" createVehicleLocal _impactPos;
_rockEmitter setParticleCircle [20, [0, 0, 0]];
_rockEmitter setParticleRandom [7, [0.3, 0.3, 0], [_velocityX * 5, _velocityY * 5, 100], 0, 0.5, [0, 0, 0, 0.1], 0.2, 0];
_rockEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 10, [0, 0, 0], [_velocityX * 2, _velocityY * 2, 150], 2, 200, 5, 3, [2, 2, 2], [[0, 0, 0, 1], [0, 0, 0, 0.5], [0.5, 0.5, 0.5, 0]], [0.125], 0.5, 0, "", "", _impactPos, 0, true, 0.6, [[0, 0, 0, 0]]];
_rockEmitter setDropInterval (0.005 / _budget);

private _blastEmitter = objNull;
private _shockwaveEmitter = objNull;
if (_shockwave) then {
    _blastEmitter = "#particlesource" createVehicleLocal _impactPos;
    _blastEmitter setParticleCircle [0, [0, 0, 0]];
    _blastEmitter setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
    _blastEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 0], [0, 0, -100], 15, 100, 3, 1, [30, 800], [[0.5, 0.5, 0.5, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 0, 0, "", "", _impactPos];
    _blastEmitter setDropInterval 60;

    _shockwaveEmitter = "#particlesource" createVehicleLocal _impactPos;
    _shockwaveEmitter setParticleCircle [5, [100, 100, 0]];
    _shockwaveEmitter setParticleRandom [5, [5, 5, 0], [-100, -100, 0], 0, 2, [0, 0, 0, 0.5], 0, 0];
    _shockwaveEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, -5], 0, 20, 1, 0.0001, [10, 30], [[0, 0, 0, 0.1], [0.5, 0.5, 0.5, 0]], [0.08], 0, 0, "", "", _impactPos];
    _shockwaveEmitter setDropInterval 0.0001;
};

private _smokeEmitter = "#particlesource" createVehicleLocal _impactPos;
_smokeEmitter setParticleCircle [40, [0, 0, 0]];
_smokeEmitter setParticleRandom [0.5, [1, 1, 0], [50, 50, 70], 3, 0.5, [0, 0, 0, 1], 1, 0];
_smokeEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 0], [0, 0, 20], 5, 30, 5, 1, [30, 50, 100], [[0, 0, 0, 1], [0, 0, 0, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _impactPos];
_smokeEmitter setDropInterval (0.01 / _budget);

"Crater" createVehicleLocal _impactPos;

private _impactLight = "#lightpoint" createVehicleLocal _impactPos;
_impactLight setLightIntensity 5000;
_impactLight setLightDayLight true;
_impactLight setLightAttenuation [800, 100, 10, 0, 5, 800];
_impactLight setLightFlareSize 100;
_impactLight setLightFlareMaxDistance 2000;
_impactLight setLightAmbient [1, 0.5, 0];
_impactLight setLightColor [1, 0.5, 0];

// The bang arrives later the further away the player stands.
private _soundSource = "Land_HelipadEmpty_F" createVehicleLocal _impactPos;
private _soundDelay = linearConversion [0, 2000, player distance _impactPos, 0, 1, true];
private _shakePower = linearConversion [0, 2000, player distance _impactPos, 6, 0.1, true];

[{
    params ["_soundSource", "_shakePower"];
    _soundSource say3D [QGVAR(impact), 3000];
    enableCamShake true;
    addCamShake [_shakePower, 5, 35];
}, [_soundSource, _shakePower], _soundDelay] call CBA_fnc_waitAndExecute;

[{
    params ["_splashHot", "_shockwaveEmitter"];
    deleteVehicle _splashHot;
    deleteVehicle _shockwaveEmitter;
}, [_splashHot, _shockwaveEmitter], 0.5] call CBA_fnc_waitAndExecute;

[{
    params ["_smokeEmitter", "_impactLight", "_blastEmitter", "_rockEmitter"];
    deleteVehicle _smokeEmitter;
    deleteVehicle _impactLight;
    deleteVehicle _blastEmitter;
    deleteVehicle _rockEmitter;
    playSound QGVAR(earthquake_rumble);
}, [_smokeEmitter, _impactLight, _blastEmitter, _rockEmitter], 1] call CBA_fnc_waitAndExecute;

[{
    addCamShake [0.5, 30, 35];
}, [], 2 + random 1] call CBA_fnc_waitAndExecute;

[{
    params ["_soundSource"];
    deleteVehicle _soundSource;
}, [_soundSource], 8] call CBA_fnc_waitAndExecute;
