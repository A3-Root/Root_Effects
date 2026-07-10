#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one aurora borealis: a wide band of colored plasma
 * lights across the night sky. A slow watcher loop shows the band at night,
 * hides it during the day and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor] call root_effects_ambientsfx_fnc_auroraStartLocal
 */

params [["_anchor", objNull, [objNull]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, emitter]
private _state = [_anchor, objNull];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_emitter"];

    if (isNull _anchor) exitWith {
        deleteVehicle _emitter;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _active = sunOrMoon == 0;

    if (_active && {isNull _emitter}) then {
        private _plasmaWave = "#particlesource" createVehicleLocal getPosATL _anchor;
        _plasmaWave setParticleCircle [0, [0, 0, 0]];
        _plasmaWave setParticleRandom [5, [2500, 20, 10], [0, 0, 0], 10, 0, [0, 0, 0, 0], 1, 0];
        _plasmaWave setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 180, [0, 0, 0], [0, 0, 0], 13, 9.999, 7.9, 0.005, [150, 150, 150, 300], [[0, 1, 0, 0], [0, 1, 0, 1], [0, 0.3, 0.7, 0.5], [0.9, 0, 0.7, 1], [0.4, 0, 0.2, 0]], [0.08], 1, 0, "", "", _anchor];
        _plasmaWave setDropInterval (0.05 / ((EGVAR(main,particleBudget)) max 0.1));
        _args set [1, _plasmaWave];
    };

    if (!_active && {!isNull _emitter}) then {
        deleteVehicle _emitter;
        _args set [1, objNull];
    };
}, 2, _state] call CBA_fnc_addPerFrameHandler;
