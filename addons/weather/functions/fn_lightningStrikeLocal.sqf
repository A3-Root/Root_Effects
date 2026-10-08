#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side visuals for one lightning strike: a bolt model, a blinding
 * flicker that lights up the surroundings, and thunder delayed by the
 * player's distance from the strike. The server's lightning ammo handles the
 * real impact; this only adds what the ammo does not show.
 *
 * Arguments:
 * 0: Strike position ATL <ARRAY>
 * 1: Storm strength 0..1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [getPosATL player, 0.7] call root_effects_weather_fnc_lightningStrikeLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_strength", 0.7, [0]]];

if (!hasInterface) exitWith {};

private _distance = player distance2D _pos;
if (_distance > ((EGVAR(main,maxViewDistance)) max 3000)) exitWith {};
DBG(FORMAT_1("lightningStrikeLocal running here with %1",_this));

private _bolt = (selectRandom ["Lightning1_F", "Lightning2_F"]) createVehicleLocal _pos;
_bolt setDir random 360;
_bolt setPosATL _pos;

private _light = "#lightpoint" createVehicleLocal (_pos vectorAdd [0, 0, 30]);
_light setLightDayLight true;
_light setLightColor [0.85, 0.9, 1];
_light setLightAmbient [0.6, 0.65, 0.9];
_light setLightAttenuation [10, 0, 0, 0.0005, 500, 2000];
_light setLightBrightness 0;

// Real lightning flickers: a main flash and a few quick return strokes.
private _brightness = 40 + 80 * _strength;
private _time = 0;
for "_i" from 0 to (1 + floor random 3) do {
    private _level = [_brightness * (0.3 + random 0.6), _brightness] select (_i == 0);
    [{(_this select 0) setLightBrightness (_this select 1)}, [_light, _level], _time] call CBA_fnc_waitAndExecute;
    [{(_this select 0) setLightBrightness 0}, [_light], _time + 0.05 + random 0.08] call CBA_fnc_waitAndExecute;
    _time = _time + 0.1 + random 0.15;
};

[{
    params ["_bolt", "_light"];
    deleteVehicle _bolt;
    deleteVehicle _light;
}, [_bolt, _light], _time + 0.3] call CBA_fnc_waitAndExecute;

// Sound travels at roughly 340 m/s, so distant strikes rumble later.
[{
    params ["_pos", "_distance"];
    private _sound = ["A3\Sounds_F\ambient\thunder\thunder_02.wss", "A3\Sounds_F\ambient\thunder\thunder_06.wss"] select (_distance > 600);
    playSound3D [_sound, objNull, false, ATLToASL _pos, 5, 0.9 + random 0.2, 4000];
}, [_pos, _distance], _distance / 340] call CBA_fnc_waitAndExecute;
