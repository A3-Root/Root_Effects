#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one seeker visit: a landing beam, dust shockwave
 * and crater, then a glowing orb hopping between random spots and sweeping
 * arcs around them, humming while it searches. It finally launches back into
 * the sky. Everything is local and cleans itself up.
 *
 * Arguments:
 * 0: Visit position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0]] call root_effects_ufo_fnc_seekerLocal
 */

params [["_visitPos", [0, 0, 0], [[]], 3]];

if (!hasInterface) exitWith {};
if ((player distance2D _visitPos) > EGVAR(main,maxViewDistance)) exitWith {};

enableCamShake true;
playSound3D [QPATHTOF(sounds\ufo_landing.ogg), objNull, false, [_visitPos select 0, _visitPos select 1, 200], 10, 1, 3000];

[{
    params ["_visitPos"];

    private _orbitCenter = "Sign_Sphere100cm_F" createVehicleLocal _visitPos;
    _orbitCenter setObjectTexture [0, "#(argb,8,8,3)color(1,1,1,0,ca)"];

    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 2.5, [0, 0, 500], [0, 0, -200], 0, 9, 7, 0, [1, 10], [[0, 0, 1, 1], [0.9, 0.9, 1, 1]], [1], 0, 0, "", "", _orbitCenter];

    [{
        params ["_visitPos", "_orbitCenter"];

        for "_i" from 1 to 3 do {
            drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 0.5, 1, [0, 0, 0], [0, 0, 0], 0, 9, 7, 0, [1, 10, 0.5], [[0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0]], [1], 0, 0, "", "", _orbitCenter];
        };

        private _shockwaveEmitter = "#particlesource" createVehicleLocal getPosATL _orbitCenter;
        _shockwaveEmitter setParticleCircle [5, [0, 0, 0]];
        _shockwaveEmitter setParticleRandom [0.1, [3, 3, 1], [100, 100, 0], 0, 2, [0, 0, 0, 0.5], 1, 0];
        _shockwaveEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [1, 1, 2], [0, 0, -5], 0, 20, 1, 1, [5, 10], [[0.05, 0.04, 0.03, 0.5], [0.05, 0.04, 0.03, 0]], [1], 1, 0, "", "", _orbitCenter];
        _shockwaveEmitter setDropInterval 0.002;
        [{
            params ["_shockwaveEmitter"];
            deleteVehicle _shockwaveEmitter;
        }, [_shockwaveEmitter], 0.2] call CBA_fnc_waitAndExecute;

        "Crater" createVehicleLocal getPos _orbitCenter;
        drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 3, [0, 0, 1], [0, 0, 10], 0, 50, 0.01, 0, [10, 25], [[0.1, 0.1, 0.1, 1], [0.1, 0.1, 0.1, 1]], [1000], 1, 0, "", "", _orbitCenter];

        private _orbitLight = "#lightpoint" createVehicleLocal _visitPos;
        _orbitLight setLightDayLight true;
        _orbitLight setLightUseFlare true;
        _orbitLight setLightFlareSize 5;
        _orbitLight setLightFlareMaxDistance 5000;
        _orbitLight setLightAmbient [0.5, 0.5, 1];
        _orbitLight setLightColor [0.5, 0.7, 0.9];
        _orbitLight setLightAttenuation [0, 0, 0, 0, 0, 4000];
        _orbitLight setLightBrightness 10;

        addCamShake [2, 10, 30];
        playSound QGVAR(rumble);

        // Hop between random spots, sweeping an arc around each one.
        // [center, light, jumpsLeft, arcStepsLeft, rotationAngle, orbitRadius, clockwise, nextHumTime]
        [{
            params ["_args", "_handle"];
            _args params ["_orbitCenter", "_orbitLight", "_jumpsLeft", "_arcSteps", "_rotationAngle", "_orbitRadius", "_clockwise", "_nextHum"];

            if (CBA_missionTime >= _nextHum) then {
                _orbitLight say3D [QGVAR(charge_2), 400];
                _args set [7, CBA_missionTime + 4];
            };

            if (_arcSteps <= 0) then {
                if (_jumpsLeft <= 0) exitWith {
                    _handle call CBA_fnc_removePerFrameHandler;

                    playSound3D [QPATHTOF(sounds\ufo_launch.ogg), objNull, false, [getPos _orbitLight select 0, getPos _orbitLight select 1, 200], 10, 1, 3000];
                    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 2.5, [0, 0, 0], [0, 0, 200], 0, 9, 7, 0, [10, 1], [[1, 1, 1, 1], [0.9, 0.9, 1, 1]], [1], 0, 0, "", "", _orbitLight];

                    [{
                        params ["_orbitLight", "_orbitCenter"];
                        deleteVehicle _orbitLight;
                        deleteVehicle _orbitCenter;
                    }, [_orbitLight, _orbitCenter], 2.5] call CBA_fnc_waitAndExecute;
                };

                // Pick the next spot to inspect.
                _orbitCenter setPos (_orbitCenter getRelPos [5 + round random 20, round random 360]);
                _args set [2, _jumpsLeft - 1];
                _args set [3, round random 180];
                _args set [4, _orbitCenter getRelDir _orbitLight];
                _args set [5, _orbitLight distance _orbitCenter];
                _args set [6, selectRandom [true, false]];
            } else {
                private _arcPos = _orbitCenter getRelPos [_orbitRadius, _rotationAngle];
                _orbitLight setPos [_arcPos select 0, _arcPos select 1, 2];
                drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0], 0, 9.999, 7, 0, [1, 5], [[0.443, 0.706, 0.81, 0.2], [0.443, 0.706, 0.81, 0]], [1], 0, 0, "", "", _orbitLight];
                drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 0.2, 0.5, [1, 1, 0], [0, 0, 0], 0, 9, 7, 0, [1, 10, 0.5], [[0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0]], [1], 0, 0, "", "", _orbitLight];

                _args set [3, _arcSteps - 1];
                _args set [4, _rotationAngle + ([-1, 1] select _clockwise)];
            };
        }, 0.02, [_orbitCenter, _orbitLight, 4 + round random 33, 0, 0, 0, true, 0]] call CBA_fnc_addPerFrameHandler;
    }, [_visitPos, _orbitCenter], 2] call CBA_fnc_waitAndExecute;
}, [_visitPos], 1.3] call CBA_fnc_waitAndExecute;
