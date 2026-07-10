#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one spacetime rupture: a shimmering band of
 * volumetric lights in the night sky. A slow watcher loop shows the band at
 * night, hides it during the day and ends itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor] call root_effects_ambientsfx_fnc_ruptureStartLocal
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
        private _rupture = "#particlesource" createVehicleLocal getPosATL _anchor;
        _rupture setParticleCircle [0, [0, 0, 0]];
        _rupture setParticleRandom [10, [2000, 5, 5], [0, 0, 0], 0.01, 1, [0, 0, 0, 0.1], 1, 0];
        _rupture setParticleParams [["\A3\data_f\VolumeLight", 1, 0, 1], "", "SpaceObject", 1, 180, [0, 0, 0], [0, 0, 0], 0, 9.996, 7.84, 0, [20, 30, 20], [[0, 0, 0, 0], [1, 1, 0.25, 1], [0.5, 1, 0.5, 0]], [0.08], 1, 0, "", "", _anchor];
        _rupture setDropInterval (0.05 / ((EGVAR(main,particleBudget)) max 0.1));
        _args set [1, _rupture];
    };

    if (!_active && {!isNull _emitter}) then {
        deleteVehicle _emitter;
        _args set [1, objNull];
    };
}, 2, _state] call CBA_fnc_addPerFrameHandler;
