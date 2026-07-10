#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one ambient tracer source: recurring volleys of
 * glowing projectiles rising into the sky, plus a throttled distant gunfire
 * sound. Tracers only appear while the player is beyond the activation
 * distance, so nobody sees them spawn. Everything is local; the loop ends
 * itself once the anchor is deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Minimum player distance before tracers are shown <NUMBER>
 * 2: Tracer color as [r, g, b] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 150, [1, 1, 1]] call root_effects_battlescripts_fnc_tracersStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_activationDistance", 150, [0]], ["_color", [1, 1, 1], [[]], 3]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, activationDistance, color, nextVolleyTime, nextSoundTime]
private _state = [_anchor, _activationDistance, _color, 0, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_activationDistance", "_color", "_nextVolley", "_nextSound"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    if (CBA_missionTime < _nextVolley) exitWith {};
    _args set [3, CBA_missionTime + 1 + random 3];

    private _distance = player distance _anchor;
    if (_distance <= _activationDistance || {_distance > EGVAR(main,maxViewDistance)}) exitWith {};

    if (CBA_missionTime >= _nextSound) then {
        _anchor say3D [QGVAR(tracer_fire), 2000];
        _args set [4, CBA_missionTime + 33 + random 4];
    };

    // One volley shares a common firing solution with a little jitter.
    private _velocityX = (floor random 60) * selectRandom [1, -1];
    private _velocityY = (floor random 60) * selectRandom [1, -1];
    private _velocityZ = 70 + floor random 100;
    private _lifetime = 3 + floor random 10;

    for "_i" from 1 to (2 + floor random 8) do {
        [{
            params ["_anchor", "_velocity", "_color", "_lifetime"];
            if (isNull _anchor) exitWith {};

            private _tracer = "Land_Battery_F" createVehicleLocal getPosATL _anchor;
            _tracer setPosATL getPosATL _anchor;
            _tracer setVelocity _velocity;

            private _tracerLight = "#lightpoint" createVehicleLocal getPosATL _anchor;
            _tracerLight setLightAmbient _color;
            _tracerLight setLightColor _color;
            _tracerLight lightAttachObject [_tracer, [0, 0, 0]];
            _tracerLight setLightDayLight true;
            _tracerLight setLightUseFlare true;
            _tracerLight setLightFlareSize 3;
            _tracerLight setLightFlareMaxDistance 5000;
            _tracerLight setLightIntensity 5000;
            _tracerLight setLightAttenuation [2, 0, 100, 0, 2, 2];

            [{
                params ["_tracer", "_tracerLight"];
                deleteVehicle _tracer;
                deleteVehicle _tracerLight;
            }, [_tracer, _tracerLight], _lifetime] call CBA_fnc_waitAndExecute;
        }, [_anchor, [_velocityX + random 1.5, _velocityY + random 1.5, _velocityZ + random 1.5], _color, _lifetime], _i * (0.2 + random 1)] call CBA_fnc_waitAndExecute;
    };
}, 0.5, _state] call CBA_fnc_addPerFrameHandler;
