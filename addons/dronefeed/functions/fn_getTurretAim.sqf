#include "..\script_component.hpp"

/*
 * Author: Root
 * Resolves the world camera position and aim direction for a drone feed. The
 * gunner view follows the turret gimbal by reading the live weapon direction,
 * with animated gun memory points and finally the static camera memory points
 * as fallbacks, so the picture tracks where the operator actually slews rather
 * than freezing on a fixed hull point. The driver view uses the fixed nose
 * camera memory points.
 *
 * Arguments:
 * 0: Drone <OBJECT>
 * 1: View, "GUNNER" or "DRIVER" <STRING>
 *
 * Return Value:
 * [camera position ASL, normalized aim direction] <ARRAY>
 *
 * Example:
 * [_drone, "GUNNER"] call root_effects_dronefeed_fnc_getTurretAim
 */

params [["_drone", objNull, [objNull]], ["_view", VIEW_GUNNER, [""]]];

if (isNull _drone) exitWith {[[0, 0, 0], [0, 1, 0]]};

private _cfg = configOf _drone;

// Driver: fixed forward looking nose camera.
if (_view isEqualTo VIEW_DRIVER) exitWith {
    private _posSel = getText (_cfg >> "uavCameraDriverPos");
    private _dirSel = getText (_cfg >> "uavCameraDriverDir");
    if (_posSel isEqualTo "") then {_posSel = "PiP0_pos"};
    if (_dirSel isEqualTo "") then {_dirSel = "PiP0_dir"};

    private _camPos = _drone modelToWorldVisualWorld (_drone selectionPosition [_posSel, "Memory"]);
    private _dirPos = _drone modelToWorldVisualWorld (_drone selectionPosition [_dirSel, "Memory"]);
    private _dir = _camPos vectorFromTo _dirPos;
    if (_dir isEqualTo [0, 0, 0]) then {_dir = vectorDir _drone};
    [_camPos, vectorNormalized _dir]
};

// Gunner camera origin from the configured memory point.
private _posSel = getText (_cfg >> "uavCameraGunnerPos");
if (_posSel isEqualTo "") then {_posSel = "PiP1_pos"};
private _camPos = _drone modelToWorldVisualWorld (_drone selectionPosition [_posSel, "Memory"]);

// Primary: the turret weapon direction, which rotates with the gimbal.
private _dir = [0, 0, 0];
private _weapons = _drone weaponsTurret [0];
if (_weapons isNotEqualTo []) then {
    _dir = _drone weaponDirection (_weapons select 0);
};

// Fallback: animated gun memory points, skinned to the turret bones.
if (_dir isEqualTo [0, 0, 0]) then {
    private _gunBeg = _drone selectionPosition ["gunBeg", "Memory"];
    private _gunEnd = _drone selectionPosition ["gunEnd", "Memory"];
    if (_gunBeg isNotEqualTo _gunEnd) then {
        _dir = (_drone modelToWorldVisualWorld _gunBeg) vectorFromTo (_drone modelToWorldVisualWorld _gunEnd);
    };
};

// Last resort: the static direction memory point (the old fixed behaviour).
if (_dir isEqualTo [0, 0, 0]) then {
    private _dirSel = getText (_cfg >> "uavCameraGunnerDir");
    if (_dirSel isEqualTo "") then {_dirSel = "PiP1_dir"};
    _dir = _camPos vectorFromTo (_drone modelToWorldVisualWorld (_drone selectionPosition [_dirSel, "Memory"]));
};

if (_dir isEqualTo [0, 0, 0]) then {_dir = vectorDir _drone};

[_camPos, vectorNormalized _dir]
