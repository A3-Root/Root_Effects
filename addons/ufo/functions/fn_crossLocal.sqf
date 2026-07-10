#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one UFO crossing: a glowing halo attached to the
 * body and cloud puffs at entry and exit. Once the crossing completes the
 * glow fades out and everything cleans itself up.
 *
 * Arguments:
 * 0: UFO body <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ufo] call root_effects_ufo_fnc_crossLocal
 */

params [["_ufo", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _ufo) exitWith {};

private _cloud = "#particlesource" createVehicleLocal getPos _ufo;
_cloud setParticleCircle [0, [0, 0, 0]];
_cloud setParticleRandom [0, [1500, 1500, 100], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_cloud setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, -1500], [0, 0, 50], 3, 10, 7.9, 0, [400, 450, 500], [[0.1, 0.1, 0.5, 0], [1, 1, 1, 0.3], [0, 0, 0.5, 0]], [0], 0, 0, "", "", _ufo];
_cloud setDropInterval 0.002;
[{
    params ["_cloud"];
    deleteVehicle _cloud;
}, [_cloud], 0.5] call CBA_fnc_waitAndExecute;

private _glow = "#lightpoint" createVehicleLocal getPosATL _ufo;
_glow setLightDayLight true;
_glow setLightUseFlare true;
_glow setLightFlareSize 15;
_glow setLightFlareMaxDistance 5000;
_glow setLightAmbient [0.5, 0.5, 1];
_glow setLightColor [0.443, 0.706, 0.9];
_glow setLightAttenuation [0, 0, 0, 0, 0, 4000];
_glow setLightIntensity 10;
_glow setLightBrightness 10;
_glow attachTo [_ufo, [0, 0, 0]];

// Wait for the exit climb, then puff a cloud in overcast and fade the glow.
// [ufo, glow, phase (0 waiting, then fading flare size)]
[{
    params ["_args", "_handle"];
    _args params ["_ufo", "_glow", "_flareSize"];

    if (_flareSize < 0 || {isNull _glow}) exitWith {
        deleteVehicle _glow;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    if (_flareSize == 16) then {
        // Still waiting for the crossing to finish.
        if (!isNull _ufo && {!(_ufo getVariable [QGVAR(crossComplete), false])}) exitWith {};

        if (!isNull _ufo && {overcast > 0.5}) then {
            private _exitCloud = "#particlesource" createVehicleLocal getPos _ufo;
            _exitCloud setParticleCircle [0, [0, 0, 0]];
            _exitCloud setParticleRandom [0, [1500, 1500, 100], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
            _exitCloud setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, 500], [0, 0, 50], 3, 10, 7.9, 0, [400, 450, 500], [[0.1, 0.1, 0.5, 0], [1, 1, 1, 0.3], [0, 0, 0.5, 0]], [0], 0, 0, "", "", _ufo];
            _exitCloud setDropInterval 0.002;
            [{
                params ["_exitCloud"];
                deleteVehicle _exitCloud;
            }, [_exitCloud], 0.5] call CBA_fnc_waitAndExecute;
        };
        _args set [2, 15];
    } else {
        _glow setLightFlareSize _flareSize;
        _args set [2, _flareSize - 1];
    };
}, 0.2, [_ufo, _glow, 16]] call CBA_fnc_addPerFrameHandler;
