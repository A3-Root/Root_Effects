#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side animation of one crop circle: a landing sequence with tremor
 * and shockwave, then a glowing orb tracing the chosen pattern while burning
 * flattened decals into the ground, and a final launch back into the sky.
 * The decals persist as the finished crop circle; everything else is local
 * and cleans itself up. Deleting the instance anchor aborts the animation.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Circle radius in meters <NUMBER>
 * 2: Pattern "circle", "spiral" or "flower" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 50, "circle"] call root_effects_ufo_fnc_cropCircleLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 50, [0]], ["_cropType", "circle", [""]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};
if ((player distance2D _anchor) > EGVAR(main,maxViewDistance)) exitWith {};

enableCamShake true;
playSound3D [QPATHTOF(sounds\ufo_landing.ogg), objNull, false, [getPos _anchor select 0, getPos _anchor select 1, 200], 10, 1, 0];

[{
    addCamShake [2, 10, 30];
    playSound QGVAR(rumble);
}, [], 3.9] call CBA_fnc_waitAndExecute;

[{
    params ["_anchor", "_radius", "_cropType"];
    if (isNull _anchor) exitWith {};

    private _orbitLight = "#lightpoint" createVehicleLocal [0, 0, 0];
    _orbitLight setLightDayLight true;
    _orbitLight setLightUseFlare true;
    _orbitLight setLightFlareSize 5;
    _orbitLight setLightFlareMaxDistance 5000;
    _orbitLight setLightAmbient [0.5, 0.5, 1];
    _orbitLight setLightColor [0.443, 0.706, 0.9];
    _orbitLight setLightAttenuation [0, 0, 0, 0, 0, 4000];
    _orbitLight setLightBrightness 5;

    drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 2.5, [0, 0, 500], [0, 0, -200], 0, 9, 7, 0, [1, 10], [[0, 0, 1, 1], [0.9, 0.9, 1, 1]], [1], 0, 0, "", "", _anchor];

    private _shockwaveEmitter = "#particlesource" createVehicleLocal getPos _anchor;
    _shockwaveEmitter setParticleCircle [5, [0, 0, 0]];
    _shockwaveEmitter setParticleRandom [0.1, [3, 3, 1], [100, 100, 0], 0, 2, [0, 0, 0, 0.5], 1, 0];
    _shockwaveEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [1, 1, 2], [0, 0, -5], 0, 20, 1, 1, [5, 10], [[0, 0, 0, 0.3], [0.1, 0.1, 0.1, 0]], [1], 1, 0, "", "", _anchor];
    _shockwaveEmitter setDropInterval 0.002;
    [{
        params ["_shockwaveEmitter"];
        deleteVehicle _shockwaveEmitter;
    }, [_shockwaveEmitter], 0.2] call CBA_fnc_waitAndExecute;

    [_anchor, "Crater" createVehicleLocal getPos _anchor] call EFUNC(main,registerLocalObject);

    // Pattern tracer. Per tick the orb advances one degree, drops its glow
    // and occasionally burns a flattened decal into the ground.
    // flower patterns additionally hop between petal centers.
    private _petalCenter = objNull;
    private _decalSpacing = [12, 4] select (_radius >= 50);
    if (_cropType isEqualTo "spiral") then {
        _decalSpacing = 2;
    };
    if (_cropType isEqualTo "flower") then {
        _petalCenter = "Sign_Sphere100cm_F" createVehicleLocal [0, 0, 0];
        _petalCenter setObjectTexture [0, "#(argb,8,8,3)color(1,1,1,0,ca)"];
        _petalCenter setPos (_anchor getRelPos [_radius, 0]);
        _decalSpacing = 18;
    };

    // [anchor, light, petalCenter, type, angle, petalAngle, radius, decalCountdown, nextHumTime, spacing]
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_orbitLight", "_petalCenter", "_cropType", "_angle", "_petalAngle", "_radius", "_decalCountdown", "_nextHum", "_decalSpacing"];

        private _finished = false;

        if (isNull _anchor) then {
            _finished = true;
        } else {
            if (CBA_missionTime >= _nextHum) then {
                _orbitLight say3D [QGVAR(crop_hum), 2000];
                _args set [8, CBA_missionTime + 17];
            };

            private _tracePos = [0, 0, 0];
            switch (_cropType) do {
                case "spiral": {
                    _tracePos = _anchor getRelPos [_radius, _angle];
                    _args set [6, _radius + 0.1];
                    _args set [4, _angle + 1];
                    if (_angle >= 1260) then {
                        _finished = true;
                    };
                };
                case "flower": {
                    _tracePos = _petalCenter getRelPos [15, 360 - _angle];
                    _args set [4, _angle + 1];
                    if (_angle >= 360) then {
                        _args set [4, 0];
                        _args set [5, _petalAngle + 30];
                        _petalCenter setPos (_anchor getRelPos [_radius, _petalAngle + 30]);
                        if (_petalAngle + 30 >= 360) then {
                            _finished = true;
                        };
                    };
                };
                default {
                    _tracePos = _anchor getRelPos [_radius, _angle];
                    _args set [4, _angle + 1];
                    if (_angle >= 360) then {
                        _finished = true;
                    };
                };
            };

            if (!_finished) then {
                _orbitLight setPos [_tracePos select 0, _tracePos select 1, 2];
                drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.3, [0, 0, 0], [0, 0, 0], 0, 9.999, 7, 0, [1, 10], [[0.443, 0.706, 0.81, 0.2], [0.443, 0.706, 0.81, 0]], [1], 0, 0, "", "", _orbitLight];

                if (_decalCountdown <= 0) then {
                    private _decal = (["Crater", "Land_ShellCrater_02_decal_F"] select (isClass (configFile >> "CfgVehicles" >> "Land_ShellCrater_02_decal_F"))) createVehicleLocal _tracePos;
                    [_anchor, _decal] call EFUNC(main,registerLocalObject);
                    _args set [7, _decalSpacing];
                } else {
                    _args set [7, _decalCountdown - 1];
                };
            };
        };

        if (_finished) then {
            _handle call CBA_fnc_removePerFrameHandler;

            playSound3D [QPATHTOF(sounds\ufo_launch.ogg), objNull, false, [getPos _orbitLight select 0, getPos _orbitLight select 1, 100], 10, 1, 3000];
            drop [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 2.5, [0, 0, 0], [0, 0, 200], 0, 9, 7, 0, [10, 1], [[1, 1, 1, 1], [0.9, 0.9, 1, 1]], [1], 0, 0, "", "", _orbitLight];

            [{
                params ["_orbitLight", "_petalCenter"];
                deleteVehicle _orbitLight;
                deleteVehicle _petalCenter;
            }, [_orbitLight, _petalCenter], 2.5] call CBA_fnc_waitAndExecute;
        };
    }, 0.01, [_anchor, _orbitLight, _petalCenter, _cropType, 0, 0, _radius, 0, 0, _decalSpacing]] call CBA_fnc_addPerFrameHandler;
}, [_anchor, _radius, _cropType], 5.2] call CBA_fnc_waitAndExecute;
