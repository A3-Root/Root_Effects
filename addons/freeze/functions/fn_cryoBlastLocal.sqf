#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side visuals for one flash freeze: a blue white shock sphere racing
 * outwards, frost clouds lifting off the ground, an ice sheen washing over the
 * surface and a cold glow at the center. Players caught inside the radius also
 * get a brief whiteout. All local and cleans itself up.
 *
 * Arguments:
 * 0: Blast center position ATL <ARRAY>
 * 1: Blast radius in meters <NUMBER>
 * 2: Seconds the frost lingers <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 80, 30] call root_effects_freeze_fnc_cryoBlastLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_radius", 80, [0]], ["_duration", 30, [0]]];

if (!hasInterface) exitWith {};

private _distance = player distance2D _pos;
if (_distance > ((EGVAR(main,maxViewDistance)) max 1000)) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;

// Shock front: a sphere of cold light expanding to the blast radius.
private _shock = "#particlesource" createVehicleLocal _pos;
_shock setParticleCircle [2, [_radius / 2, _radius / 2, _radius / 6]];
_shock setParticleRandom [0.2, [2, 2, 1], [8, 8, 4], 0, 0.2, [0, 0, 0, 0], 0, 0];
_shock setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 0.9, [0, 0, 1.5], [0, 0, 0], 0, 9.999, 7, 0, [2, 8], [[0.8, 0.95, 1, 0.9], [0.6, 0.8, 1, 0.4], [0.5, 0.7, 1, 0]], [0.1, 0.5], 0, 0, "", "", _pos];
_shock setDropInterval (0.001 / _budget);

// Ice sheen washing across the ground behind the front.
private _sheen = "#particlesource" createVehicleLocal _pos;
_sheen setParticleCircle [3, [_radius / 3, _radius / 3, 0]];
_sheen setParticleRandom [1, [_radius / 4, _radius / 4, 0.3], [3, 3, 0], 0, 0.3, [0, 0, 0, 0.1], 0, 0];
_sheen setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 6, [0, 0, 0.3], [0, 0, 0.2], 0, 10, 7.5, 0.02, [4, 14], [[0.75, 0.88, 1, 0.5], [0.7, 0.85, 1, 0.25], [0.65, 0.8, 1, 0]], [0.4, 1], 1, 0, "", "", _pos];
_sheen setDropInterval (0.01 / _budget);

// Frost fog rolling up out of the frozen ground.
private _frost = "#particlesource" createVehicleLocal _pos;
_frost setParticleCircle [_radius / 2, [0, 0, 0]];
_frost setParticleRandom [4, [_radius / 3, _radius / 3, 2], [1.5, 1.5, 1], 0, 0.4, [0, 0, 0, 0.05], 0, 0];
_frost setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 12, [0, 0, 0.5], [0, 0, 1.2], 0, 10, 7.5, 0.02, [3, 10, 16], [[0.5, 0.66, 1, 0.35], [0.6, 0.75, 1, 0.2], [0.7, 0.82, 1, 0]], [0.3, 0.8], 1, 0, "", "", _pos];
_frost setDropInterval (0.05 / _budget);

private _glow = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 3]);
_glow setLightBrightness 4;
_glow setLightColor [0.5, 0.75, 1];
_glow setLightAmbient [0.3, 0.5, 0.8];
_glow setLightAttenuation [4, 0, _radius, 0, 20, _radius * 1.5];

playSound3D ["A3\Sounds_F\sfx\blesk2.wss", objNull, false, ATLToASL _pos, 4, 0.6, 2000];

if (_distance < _radius * 2) then {
    enableCamShake true;
    addCamShake [2 * (1 - _distance / (_radius * 2)), 2, 20];
};

// Anyone standing in the blast gets the cold hitting them in the face.
if (_distance <= _radius) then {
    private _whiteout = ppEffectCreate ["ColorCorrections", 2410];
    _whiteout ppEffectEnable true;
    _whiteout ppEffectAdjust [1, 1, 0, [0.75, 0.88, 1, 0.85], [1, 1, 1, 0], [1, 1, 1, 0]];
    _whiteout ppEffectCommit 0.15;

    [{
        params ["_whiteout"];
        _whiteout ppEffectAdjust [1, 1, 0, [0.75, 0.88, 1, 0], [1, 1, 1, 0], [1, 1, 1, 0]];
        _whiteout ppEffectCommit 2.5;

        [{
            params ["_whiteout"];
            ppEffectDestroy _whiteout;
        }, [_whiteout], 3] call CBA_fnc_waitAndExecute;
    }, [_whiteout], 0.5] call CBA_fnc_waitAndExecute;
};

[{
    params ["_shock", "_glow"];
    deleteVehicle _shock;
    deleteVehicle _glow;
}, [_shock, _glow], 1.5] call CBA_fnc_waitAndExecute;

[{
    params ["_sheen"];
    deleteVehicle _sheen;
}, [_sheen], 4] call CBA_fnc_waitAndExecute;

// The fog hangs around for as long as the units stay frozen.
[{
    params ["_frost"];
    deleteVehicle _frost;
}, [_frost], _duration] call CBA_fnc_waitAndExecute;
