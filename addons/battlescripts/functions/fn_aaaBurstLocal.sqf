#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Plays one flak detonation on this client: moves the shared flash light of
 * the instance to the detonation point, plays the firing sound and after a
 * short flight delay flashes the light and plays the airburst crack.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Detonation position <ARRAY>
 * 2: Render smoke only, no flash <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, [1000, 2000, 200], false] call root_effects_battlescripts_fnc_aaaBurstLocal
 */

params [["_anchor", objNull, [objNull]], ["_burstPos", [0, 0, 0], [[]], 3], ["_smokeOnly", false, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

private _flakLight = _anchor getVariable [QGVAR(aaaLight), objNull];
if (isNull _flakLight) exitWith {};

_flakLight setPosATL _burstPos;
_flakLight say3D [QGVAR(flak_fire), 2000];

[{
    params ["_anchor", "_smokeOnly"];
    if (isNull _anchor) exitWith {};

    private _flakLight = _anchor getVariable [QGVAR(aaaLight), objNull];
    if (isNull _flakLight) exitWith {};

    if (!_smokeOnly && {random 1 < 0.6}) then {
        _flakLight setLightFlareSize (10 + random 100);
        _flakLight setLightIntensity (500 + random 500);
    };

    private _burstSound = selectRandom [QGVAR(flak_burst_1), QGVAR(flak_burst_2), QGVAR(flak_burst_3), QGVAR(flak_burst_4), QGVAR(flak_burst_5), QGVAR(flak_burst_6), QGVAR(flak_burst_7), QGVAR(flak_burst_8)];
    _flakLight say3D [_burstSound, 2000];

    [{
        params ["_anchor"];
        if (isNull _anchor) exitWith {};
        private _flakLight = _anchor getVariable [QGVAR(aaaLight), objNull];
        if (!isNull _flakLight) then {
            _flakLight setLightIntensity 0;
        };
    }, [_anchor], 0.3] call CBA_fnc_waitAndExecute;
}, [_anchor, _smokeOnly], 0.4 + random 0.5] call CBA_fnc_waitAndExecute;
