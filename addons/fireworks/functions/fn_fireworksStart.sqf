#include "..\script_component.hpp"

/*
 * Author: Root
 * Starts a fireworks display on the server: creates the anchor, broadcasts
 * the setup to all clients (JIP safe) and removes the instance once the
 * duration has passed. Every rocket, burst, light and sound is generated
 * locally by the clients, so a running display costs no network traffic.
 *
 * Arguments:
 * 0: Position ATL of the launch site <ARRAY>
 * 1: Display duration in seconds, 0 for endless <NUMBER>
 * 2: Launches per minute <NUMBER>
 * 3: Launch area radius in meters <NUMBER>
 * 4: Detonation height in meters <NUMBER>
 * 5: Play launch and burst sounds <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 120, 12, 50, 150, true] call root_effects_fireworks_fnc_fireworksStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_duration", 120, [0]],
    ["_rate", 12, [0]],
    ["_radius", 50, [0]],
    ["_height", 150, [0]],
    ["_sounds", true, [false]]
];

if (!isServer) exitWith {};
if (!(["fireworks"] call EFUNC(main,isEffectEnabled))) exitWith {};

_rate = _rate max 1;

private _anchor = ["fireworks", QGVAR(startLocal), [_rate, _radius, _height, _sounds], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

if (_duration > 0) then {
    [{
        params ["_anchor"];
        ["fireworks", _anchor] call EFUNC(main,stopEffect);
    }, [_anchor], _duration] call CBA_fnc_waitAndExecute;
};

DBG(FORMAT_2("fireworks started, %1 per minute for %2 seconds",_rate,_duration));
