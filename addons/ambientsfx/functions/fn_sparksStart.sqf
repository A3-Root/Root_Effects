#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts ambient electrical sparks on the server: creates the anchor and
 * schedules recurring spark burst windows. Each window sends one event and
 * every client staggers its own bursts locally, so the network only carries
 * one message per window.
 *
 * Arguments:
 * 0: Position ATL of the spark source <ARRAY>
 * 1: Altitude of the sparks above terrain in meters <NUMBER>
 * 2: Seconds between spark burst windows <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 0, 10] call root_effects_ambientsfx_fnc_sparksStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_altitude", 0, [0]],
    ["_sparkDelay", 10, [0]]
];

if (!isServer) exitWith {};
if (!(["sparks"] call EFUNC(main,isEffectEnabled))) exitWith {};

_sparkDelay = _sparkDelay max 1;

private _anchorPos = +_pos;
_anchorPos set [2, _altitude];

private _anchor = ["sparks", "", [], _anchorPos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

[{
    params ["_args", "_handle"];
    _args params ["_anchor"];

    if (isNull _anchor) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
    };

    [QGVAR(sparkBurst), [_anchor, 1 + floor random 5]] call CBA_fnc_globalEvent;
}, _sparkDelay, [_anchor]] call CBA_fnc_addPerFrameHandler;

DBG(FORMAT_1("sparks started, window delay %1",_sparkDelay));
