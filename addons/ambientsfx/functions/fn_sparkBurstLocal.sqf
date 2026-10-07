#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Plays one window of electrical spark bursts on this client: a handful of
 * short white or orange spark showers with crackle sounds, staggered by
 * random pauses. Only runs while the player is close to the source. All
 * emitters are local and clean themselves up.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Number of bursts in this window <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 3] call root_effects_ambientsfx_fnc_sparkBurstLocal
 */

params [["_anchor", objNull, [objNull]], ["_burstCount", 3, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};
if ((player distance _anchor) > 200) exitWith {};

private _delay = 0;
for "_i" from 1 to _burstCount do {
    _delay = _delay + 0.1 + random 2;

    [{
        params ["_anchor"];
        if (isNull _anchor) exitWith {};
        if ((player distance _anchor) > 200) exitWith {};

        private _sparkSound = selectRandom [QGVAR(spark_1), QGVAR(spark_2), QGVAR(spark_3), QGVAR(spark_4), QGVAR(spark_5), QGVAR(spark_6), QGVAR(spark_7)];
        private _orange = selectRandom [true, false];
        private _lifetime = [0.1 + random 0.4, 0.5 + random 1.5] select _orange;

        private _sparkEmitter = "#particlesource" createVehicleLocal getPosATL _anchor;
        if (_orange) then {
            _sparkEmitter setParticleCircle [0, [0, 0, 0]];
            _sparkEmitter setParticleRandom [1, [0.1, 0.1, 0.1], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
            // Hot orange sparks cooling to a dull ember as they fall. A crisp
            // point texture keeps each spark sharp instead of a soft blur.
            _sparkEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1 + random 2, [0, 0, 0], [0, 0, 0], 0, 15, 7.9, 0, [0.5, 0.35, 0.04], [[3, 2.4, 1.4, 1], [2.2, 1.1, 0.25, 1], [1.2, 0.35, 0.06, 0]], [0.08], 1, 0, "", "", _anchor, 0, true, 0.3, [[300, 180, 60, 1], [160, 60, 8, 1], [20, 4, 0, 0]]];
            _sparkEmitter setDropInterval (0.001 + random 0.05);
        } else {
            _sparkEmitter setParticleCircle [0, [0, 0, 0]];
            _sparkEmitter setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
            // Electrical arc sparks: white hot with a cold blue tail. A crisp
            // point texture keeps each spark sharp instead of a soft blur.
            _sparkEmitter setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 1 + random 2, [0, 0, 0], [0, 0, 0], 0, 20, 7.9, 0, [0.5, 0.35, 0.04], [[3, 3, 3, 1], [2, 2.1, 2.6, 1], [1.1, 1.2, 1.4, 0]], [0.08], 1, 0, "", "", _anchor, 0, true, 0.3, [[400, 400, 450, 1], [150, 180, 300, 1], [10, 15, 40, 0]]];
            _sparkEmitter setDropInterval 0.001;
        };

        _anchor say3D [_sparkSound, 350];

        // Emissive colour lets the sparks glow on their own, but a brief flash
        // is what makes the surroundings react to them in the dark.
        private _flash = "#lightpoint" createVehicleLocal ((getPosATL _anchor) vectorAdd [0, 0, 0.3]);
        _flash setLightDayLight false;
        _flash setLightAmbient ([[0.4, 0.45, 0.6], [0.6, 0.35, 0.1]] select _orange);
        _flash setLightColor ([[0.8, 0.85, 1], [1, 0.6, 0.2]] select _orange);
        _flash setLightBrightness (1.5 + random 1.5);
        _flash setLightAttenuation [0.5, 0, 0, 1, 2, 15];

        // Crackling flicker for the life of the burst.
        [{
            params ["_args", "_handle"];
            _args params ["_flash", "_endTime"];
            if (isNull _flash || CBA_missionTime > _endTime) exitWith {
                _handle call CBA_fnc_removePerFrameHandler;
            };
            _flash setLightBrightness (random 3);
        }, 0.05, [_flash, CBA_missionTime + _lifetime]] call CBA_fnc_addPerFrameHandler;

        [{
            params ["_sparkEmitter", "_flash"];
            deleteVehicle _sparkEmitter;
            deleteVehicle _flash;
        }, [_sparkEmitter, _flash], _lifetime] call CBA_fnc_waitAndExecute;
    }, [_anchor], _delay] call CBA_fnc_waitAndExecute;
};
