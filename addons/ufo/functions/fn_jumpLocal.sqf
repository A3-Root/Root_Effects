#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one UFO light charge in the sky: a ring of
 * satellite lights around a growing central charge that discharges in a
 * bright flash with a distant boom, followed by dust and leaves swirling
 * around the player. Everything is local and cleans itself up.
 *
 * Arguments:
 * 0: Charge position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 800]] call root_effects_ufo_fnc_jumpLocal
 */

params [["_chargePos", [0, 0, 0], [[]], 3]];

if (!hasInterface) exitWith {};
if ((player distance2D _chargePos) > ((EGVAR(main,maxViewDistance)) max 5000)) exitWith {};

enableCamShake true;
playSound QGVAR(charge_1);

private _chargeLight = "#lightpoint" createVehicleLocal _chargePos;
_chargeLight setLightDayLight true;
_chargeLight setLightUseFlare true;
_chargeLight setLightFlareSize 0;
_chargeLight setLightFlareMaxDistance 5000;
_chargeLight setLightAmbient [0.5, 0.5, 1];
_chargeLight setLightColor [0.8, 0.8, 1];
_chargeLight setLightAttenuation [0, 0, 0, 0, 0, 4000];
_chargeLight setLightIntensity 1;
_chargeLight setLightBrightness 1;

private _satelliteLights = [];
for "_angle" from 0 to 315 step 45 do {
    private _ringLight = "#lightpoint" createVehicleLocal (_chargePos getPos [20, _angle]);
    _ringLight setPos [getPos _ringLight select 0, getPos _ringLight select 1, _chargePos select 2];
    _ringLight setLightDayLight true;
    _ringLight setLightUseFlare true;
    _ringLight setLightFlareSize 5;
    _ringLight setLightFlareMaxDistance 5000;
    _ringLight setLightAmbient [0.5, 0.5, 1];
    _ringLight setLightColor [0.8, 0.8, 1];
    _ringLight setLightAttenuation [0, 0, 0, 0, 0, 4000];
    _ringLight setLightIntensity 0;
    _ringLight setLightBrightness 1;
    _satelliteLights pushBack _ringLight;
};

// Grow the charge for eight seconds, then discharge.
[{
    params ["_args", "_handle"];
    _args params ["_chargeLight", "_satelliteLights", "_intensity", "_chargePos"];

    _intensity = _intensity + 0.3;
    _args set [2, _intensity];

    if (_intensity < 48) exitWith {
        _chargeLight setLightFlareSize (_intensity + 20);
        _chargeLight setLightIntensity _intensity;
        _chargeLight setLightBrightness _intensity;
    };

    _handle call CBA_fnc_removePerFrameHandler;

    _chargeLight setLightFlareSize 100;
    {
        deleteVehicle _x;
    } forEach _satelliteLights;

    [{
        params ["_chargeLight"];
        _chargeLight setLightFlareSize 0;
        _chargeLight setLightIntensity 0;
        _chargeLight setLightBrightness 200;
    }, [_chargeLight], 0.5] call CBA_fnc_waitAndExecute;

    [{
        params ["_chargeLight", "_chargePos"];
        deleteVehicle _chargeLight;

        playSound3D [QPATHTOF(sounds\ufo_boom.ogg), objNull, false, [_chargePos select 0, _chargePos select 1, 1000], 10, 1, 5000];

        // Swirl dust and leaves around the player after the shockwave hits.
        [{
            private _leafEmitter = "#particlesource" createVehicleLocal (getPos player);
            _leafEmitter setParticleCircle [10, [0, 0, 0]];
            _leafEmitter setParticleRandom [0, [0, 0, 1], [10, 10, 10], 0.2, 0.1, [0, 0, 0, 0], 0.5, 0.5];
            _leafEmitter setParticleParams [["\A3\data_f\ParticleEffects\Hit_Leaves\Leaves_Green.p3d", 1, 0, 1], "", "SpaceObject", 1, 7, [0, 0, 1], [-10, -10, 5], 7, 11, 5, 0.2, [3, 0.1], [[1, 1, 1, 1], [1, 1, 1, 1]], [0], 1, 1, "", "", vehicle player];
            _leafEmitter setDropInterval 0.002;

            private _dustEmitter = "#particlesource" createVehicleLocal (getPos player);
            _dustEmitter setParticleCircle [20, [-5, -5, 0]];
            _dustEmitter setParticleRandom [1, [0, 0, 0], [10, 10, 0], 1, 0, [0, 0, 0, 0.01], 0, 0];
            _dustEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, 0], 13, 10, 8, 0.1, [5, 10, 20], [[0.05, 0.04, 0.03, 0.3], [0.05, 0.04, 0.03, 0.3], [0.05, 0.04, 0.03, 0]], [1], 0, 0, "", "", vehicle player];
            _dustEmitter setDropInterval 0.01;

            addCamShake [5, 4, 30];

            [{
                params ["_leafEmitter", "_dustEmitter"];
                deleteVehicle _leafEmitter;
                deleteVehicle _dustEmitter;
            }, [_leafEmitter, _dustEmitter], 0.5] call CBA_fnc_waitAndExecute;
        }, [], 2.5] call CBA_fnc_waitAndExecute;
    }, [_chargeLight, _chargePos], 0.8] call CBA_fnc_waitAndExecute;
}, 0.05, [_chargeLight, _satelliteLights, 0, _chargePos]] call CBA_fnc_addPerFrameHandler;
