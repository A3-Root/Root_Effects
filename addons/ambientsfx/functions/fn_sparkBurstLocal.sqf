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
            // Hot orange sparks cooling to a dull ember as they fall.
            _sparkEmitter setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 1 + random 2, [0, 0, 0], [0, 0, 0], 0, 15, 7.9, 0, [0.3, 0.3, 0.05], [[1, 1, 0.9, 1], [1, 0.6, 0.15, 1], [1, 0.3, 0.05, 0]], [0.08], 1, 0, "", "", _anchor, 0, true, 0.3, [[0, 0, 0, 0]]];
            _sparkEmitter setDropInterval (0.001 + random 0.05);
        } else {
            _sparkEmitter setParticleCircle [0, [0, 0, 0]];
            _sparkEmitter setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
            // Electrical arc sparks: white hot with a cold blue tail.
            _sparkEmitter setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 1 + random 2, [0, 0, 0], [0, 0, 0], 0, 20, 7.9, 0, [0.3, 0.3, 0.05], [[1, 1, 1, 1], [0.9, 0.95, 1, 1], [0.8, 0.9, 1, 0]], [0.08], 1, 0, "", "", _anchor, 0, true, 0.3, [[0, 0, 0, 0]]];
            _sparkEmitter setDropInterval 0.001;
        };

        _anchor say3D [_sparkSound, 350];

        [{
            params ["_sparkEmitter"];
            deleteVehicle _sparkEmitter;
        }, [_sparkEmitter], _lifetime] call CBA_fnc_waitAndExecute;
    }, [_anchor], _delay] call CBA_fnc_waitAndExecute;
};
