#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side visuals for one gravity anomaly: a dark red core pulsing and a
 * distortion ripple swelling while it charges, then a collapse that drives a
 * dust vortex inwards, throws debris fountains and shakes the ground. All
 * local, cleans itself up and skips machines out of view range.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Effect radius in meters <NUMBER>
 * 2: Charge time in seconds before the collapse <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 120, 6] call root_effects_strikes_fnc_singularityLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 120, [0]], ["_chargeTime", 6, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};
if ((player distance2D _anchor) > EGVAR(main,maxViewDistance)) exitWith {};

private _budget = (EGVAR(main,particleBudget)) max 0.1;
private _pos = getPosATL _anchor;

// Charge: a core that pulses harder the closer it gets to letting go.
private _core = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 3]);
_core setLightBrightness 0.5;
_core setLightColor [0.6, 0.05, 0.1];
_core setLightAmbient [0.4, 0.02, 0.05];
_core setLightUseFlare true;
_core setLightFlareSize 3;
_core setLightFlareMaxDistance 4000;

private _ripple = "#particlesource" createVehicleLocal _pos;
_ripple setParticleCircle [_radius / 4, [0, 0, 0]];
_ripple setParticleRandom [1, [3, 3, 1], [0, 0, 0.5], 0, 0.3, [0, 0, 0, 0], 0, 0];
_ripple setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 2, [0, 0, 2], [0, 0, 1], 0, 9, 7, 0, [3, 10], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _anchor];
_ripple setDropInterval (0.05 / _budget);

playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", objNull, false, ATLToASL _pos, 3, 0.4, 2000];

// Pulse the core over the charge window, then hand over to the collapse.
[{
    params ["_args", "_handle"];
    _args params ["_core", "_stepsLeft", "_total"];

    if (_stepsLeft <= 0 || {isNull _core}) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _progress = 1 - (_stepsLeft / _total);
    _args set [1, _stepsLeft - 1];

    // Pulse rate and brightness both climb as the collapse approaches.
    private _pulse = 0.5 + 0.5 * sin (CBA_missionTime * 720 * (0.5 + _progress));
    _core setLightBrightness (0.5 + _progress * 6 * _pulse);
    _core setLightFlareSize (3 + _progress * 12 * _pulse);
}, 0.05, [_core, ceil (_chargeTime * 20), ceil (_chargeTime * 20)]] call CBA_fnc_addPerFrameHandler;

[{
    params ["_anchor", "_pos", "_radius", "_core", "_ripple", "_budget"];
    if (isNull _anchor) exitWith {
        deleteVehicle _core;
        deleteVehicle _ripple;
    };

    deleteVehicle _ripple;

    // Collapse: dust swept inwards on a tightening spiral. The negative
    // tangential velocity is what makes it swirl in rather than blow out.
    private _vortex = "#particlesource" createVehicleLocal _pos;
    _vortex setParticleCircle [_radius, [-25, -25, 0]];
    _vortex setParticleRandom [2, [_radius / 4, _radius / 4, 3], [5, 5, 2], 0, 0.4, [0, 0, 0, 0.1], 0, 0];
    _vortex setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 4, [0, 0, 1], [0, 0, 4], 0, 10, 7.5, 0.03, [4, 12, 2], [[0.3, 0.28, 0.26, 0.5], [0.35, 0.3, 0.3, 0.3], [0.4, 0.35, 0.35, 0]], [0.3, 0.8], 1, 0, "", "", _anchor];
    _vortex setDropInterval (0.006 / _budget);

    // Descending emissive core marking the moment it lets go.
    private _collapse = "#particlesource" createVehicleLocal (_pos vectorAdd [0, 0, 60]);
    _collapse setParticleCircle [0, [0, 0, 0]];
    _collapse setParticleRandom [0.3, [1, 1, 2], [0, 0, 0], 0, 0.2, [0, 0, 0, 0], 0, 0];
    _collapse setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 1.2, [0, 0, 0], [0, 0, -45], 0, 9.999, 7, 0, [6, 1], [[1, 0.25, 0.2, 1], [0.7, 0.05, 0.1, 0.6], [0.3, 0, 0.05, 0]], [0.1, 0.5], 0, 0, "", "", _pos];
    _collapse setDropInterval (0.01 / _budget);

    // Ground ripple racing outwards from the collapse.
    private _shock = "#particlesource" createVehicleLocal _pos;
    _shock setParticleCircle [4, [60, 60, 0]];
    _shock setParticleRandom [1, [3, 3, 0], [-20, -20, 0], 0, 0.5, [0, 0, 0, 0], 0, 0];
    _shock setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 1.5, [0, 0, 1], [0, 0, 0], 0, 9, 7, 0, [6, 20], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 0, 0, "", "", _anchor];
    _shock setDropInterval (0.002 / _budget);

    // Night only: the shaft the anomaly leaves behind as it drains.
    private _shaft = objNull;
    if (sunOrMoon < 0.4) then {
        _shaft = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosASL _anchor, true];
        _shaft setVectorDirAndUp [[0, 0, 1], [0, 1, 0]];
    };

    // Debris thrown clear: soil, splinters and masonry on bouncing arcs.
    private _fountains = [];
    {
        private _debris = "#particlesource" createVehicleLocal _pos;
        _debris setParticleCircle [_radius / 6, [0, 0, 0]];
        _debris setParticleRandom [2, [8, 8, 4], [20, 20, 25], 0, 0.5, [0, 0, 0, 0.2], 1, 0];
        _debris setParticleParams [[_x, 1, 0, 1], "", "SpaceObject", 1, 8, [0, 0, 2], [0, 0, 55], 1, 250, 6, 0, [1.5, 1.5, 1], [[0.25, 0.22, 0.2, 1], [0.3, 0.28, 0.25, 1], [0.35, 0.33, 0.3, 0]], [0.3, 0.8], 1, 0, "", "", _anchor, 0, true, 0.55, [[0, 0, 0, 0]]];
        _debris setDropInterval (0.05 / _budget);
        _fountains pushBack _debris;
    } forEach [
        "\A3\data_f\ParticleEffects\Universal\Mud.p3d",
        "\A3\data_f\ParticleEffects\Universal\TreePart.p3d",
        "\A3\data_f\ParticleEffects\Universal\StoneSmall.p3d"
    ];

    private _distance = player distance2D _pos;
    if (_distance < _radius * 4) then {
        private _falloff = linearConversion [0, _radius * 4, _distance, 1, 0.1, true];
        enableCamShake true;
        addCamShake [9 * _falloff, 1.5, 30];

        [{
            params ["_falloff"];
            addCamShake [3 * _falloff, 6, 18];

            [{
                params ["_falloff"];
                addCamShake [0.8 * _falloff, 20, 10];
            }, [_falloff], 5] call CBA_fnc_waitAndExecute;
        }, [_falloff], 1.5] call CBA_fnc_waitAndExecute;
    };

    // Impact, then the echo rolling back off the terrain.
    playSound3D ["A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_04.wss", objNull, false, ATLToASL _pos, 5, 0.5, 4000];
    [{
        params ["_pos"];
        playSound3D ["A3\Sounds_F\arsenal\explosives\shells\tank_shell_explosion_02.wss", objNull, false, ATLToASL _pos, 4, 0.35, 4500];
    }, [_pos], 0.8] call CBA_fnc_waitAndExecute;

    [{
        params ["_collapse", "_shock"];
        deleteVehicle _collapse;
        deleteVehicle _shock;
    }, [_collapse, _shock], 1.5] call CBA_fnc_waitAndExecute;

    [{
        params ["_fountains"];
        {
            deleteVehicle _x;
        } forEach _fountains;
    }, [_fountains], 2.5] call CBA_fnc_waitAndExecute;

    [{
        params ["_vortex", "_core", "_shaft"];
        deleteVehicle _vortex;
        deleteVehicle _core;
        deleteVehicle _shaft;
    }, [_vortex, _core, _shaft], 6] call CBA_fnc_waitAndExecute;
}, [_anchor, _pos, _radius, _core, _ripple, _budget], _chargeTime] call CBA_fnc_waitAndExecute;
