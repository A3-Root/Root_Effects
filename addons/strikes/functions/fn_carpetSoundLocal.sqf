#include "..\script_component.hpp"

/*
 * Author: Root, based on community carpet strike scripts by DCON and M9SD
 * Plays one carpet strike sound cue on this client: the jet roar when the
 * run starts, or a falling bomb whistle above an impact point. Only audible
 * within one and a half kilometers of the cue position.
 *
 * Arguments:
 * 0: Cue position ATL <ARRAY>
 * 1: Cue type "jet" or "whistle" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], "jet"] call root_effects_strikes_fnc_carpetSoundLocal
 */

params [["_pos", [0, 0, 0], [[]], 3], ["_cue", "jet", [""]]];

if (!hasInterface) exitWith {};
if ((player distance2D _pos) > 1500) exitWith {};

if (_cue isEqualTo "jet") then {
    playSound (selectRandom ["BattlefieldJet1_3D", "BattlefieldJet2_3D", "BattlefieldJet3_3D"]);
} else {
    // Local whistle source at the projected impact point; the vanilla shell
    // whistle classes need an emitting object.
    private _groundPos = +_pos;
    _groundPos set [2, 0];

    private _whistleSource = "Land_HelipadEmpty_F" createVehicleLocal _groundPos;
    _whistleSource say3D [selectRandom ["Shell1", "Shell2", "Shell3", "Shell4"], 1500];

    [{
        params ["_whistleSource"];
        deleteVehicle _whistleSource;
    }, [_whistleSource], 6] call CBA_fnc_waitAndExecute;
};
