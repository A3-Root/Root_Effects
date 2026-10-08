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

// Candidate view directions. Which one is right depends on the drone model and on
// who is driving the turret (AI gunner, a player through the UAV terminal, nobody),
// so all are gathered and the first that actually looks at the ground is used.
private _candidates = [];

// 1: where the turret's gunner (AI or remote operator) is looking.
private _gunner = gunner _drone;
if (!isNull _gunner) then {
    _candidates pushBack ["gunnerView", getCameraViewDirection _gunner];
};

// 2: the gunner camera memory points, skinned to the turret bones.
private _dirModel = _drone selectionPosition [_dirSel, "Memory"];
if (_dirModel isNotEqualTo _camModel) then {
    _candidates pushBack ["cameraPoints", _camPos vectorFromTo (_drone modelToWorldVisualWorld _dirModel)];
};

// 3: the turret gun memory points, as CBA_fnc_turretDir reads them.
private _turretCfg = [_drone, [0]] call CBA_fnc_getTurret;
private _gunBeg = _drone selectionPosition [getText (_turretCfg >> "gunBeg"), "Memory"];
private _gunEnd = _drone selectionPosition [getText (_turretCfg >> "gunEnd"), "Memory"];
if (_gunBeg isNotEqualTo _gunEnd) then {
    _candidates pushBack ["gunPoints", (_drone modelToWorldVisualWorld _gunEnd) vectorFromTo (_drone modelToWorldVisualWorld _gunBeg)];
};

// 4: the turret weapon direction.
private _weapons = _drone weaponsTurret [0];
if (_weapons isNotEqualTo []) then {
    _candidates pushBack ["weapon", _drone weaponDirection (_weapons select 0)];
};

_candidates = _candidates select {(_x select 1) isNotEqualTo [0, 0, 0]};

// A drone camera looks down at the ground; a candidate pointing at the sky is a
// model whose points or weapon do not follow the gimbal.
private _pick = _candidates findIf {((vectorNormalized (_x select 1)) select 2) < 0.15};
if (_pick == -1) then {_pick = [-1, 0] select (_candidates isNotEqualTo [])};
private _dir = [vectorDir _drone, (_candidates select _pick) select 1] select (_pick != -1);
private _source = ["hull", (_candidates select _pick) select 0] select (_pick != -1);

// Log the choice now and then, so a wrong picture can be traced in the RPT.
if (diag_tickTime > (_drone getVariable [QGVAR(aimLogAt), 0])) then {
    _drone setVariable [QGVAR(aimLogAt), diag_tickTime + 10];
    private _summary = _candidates apply {[_x select 0, (vectorNormalized (_x select 1)) apply {_x toFixed 2}]};
    DBG(FORMAT_4("gunner aim for %1: using %2, candidates %3, camera point %4",typeOf _drone,_source,_summary,_posSel));
};

[_camPos, vectorNormalized _dir]
