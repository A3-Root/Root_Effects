#include "..\script_component.hpp"

/*
 * Author: Root
 * Resolves the world camera position and aim direction for a drone feed. The
 * gunner view follows the turret gimbal through the gunner camera memory points,
 * which are skinned to the turret bones, with the turret gun memory points and
 * the gunner's eye direction as fallbacks, so the picture tracks where the
 * operator actually slews. The driver view uses the fixed nose camera memory
 * points.
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
private _dirSel = getText (_cfg >> "uavCameraGunnerDir");
if (_posSel isEqualTo "") then {_posSel = "PiP1_pos"};
if (_dirSel isEqualTo "") then {_dirSel = "PiP1_dir"};

private _camModel = _drone selectionPosition [_posSel, "Memory"];
private _camPos = _drone modelToWorldVisualWorld _camModel;

// Primary: the gunner camera memory points. They are skinned to the turret bones, so
// they swing with the gimbal wherever the operator (or the AI gunner) points it.
private _dir = [0, 0, 0];
private _dirModel = _drone selectionPosition [_dirSel, "Memory"];
if (_dirModel isNotEqualTo _camModel) then {
    _dir = _camPos vectorFromTo (_drone modelToWorldVisualWorld _dirModel);
};

// Fallback: the turret's gun memory points, same as CBA_fnc_turretDir.
if (_dir isEqualTo [0, 0, 0]) then {
    private _turretCfg = [_drone, [0]] call CBA_fnc_getTurret;
    private _gunBeg = _drone selectionPosition [getText (_turretCfg >> "gunBeg"), "Memory"];
    private _gunEnd = _drone selectionPosition [getText (_turretCfg >> "gunEnd"), "Memory"];
    if (_gunBeg isNotEqualTo _gunEnd) then {
        _dir = (_drone modelToWorldVisualWorld _gunEnd) vectorFromTo (_drone modelToWorldVisualWorld _gunBeg);
    };
};

// Last resort: where the gunner is looking.
if (_dir isEqualTo [0, 0, 0] && {!isNull gunner _drone}) then {
    _dir = eyeDirection (gunner _drone);
};

if (_dir isEqualTo [0, 0, 0]) then {_dir = vectorDir _drone};

[_camPos, vectorNormalized _dir]
