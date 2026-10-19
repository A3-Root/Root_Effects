#include "..\script_component.hpp"

/*
 * Author: Root
 * Applies, keeps up or recovers the EMP effect on one local unit or vehicle.
 * - Player: gear suppression loop (and fry), voice channels, HUD interference.
 * - AI: goggles off, weapon lights and lasers off.
 * - Vehicle: engine and lights off, engine hitpoints wrecked until recovery,
 *   thermal and night optics off, fuel drain;
 *   destroy mode also wrecks engine, avionics, electrics and light hitpoints.
 * Fried and destroyed items stay broken on recovery.
 *
 * Arguments:
 * 0: Unit or vehicle <OBJECT>
 * 1: Field settings <HASHMAP>
 * 2: "apply", "enforce" or "restore" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _cfg, "apply"] call root_effects_emp_fnc_empApply
 */

params [["_entity", objNull, [objNull]], ["_cfg", createHashMap, [createHashMap]], ["_action", "apply", [""]]];

if (isNull _entity) exitWith {};

if (_action isEqualTo "restore") then {
    _entity setVariable [QGVAR(state), nil];
};
if (!local _entity) exitWith {};

// Player
if (_entity isEqualTo player) exitWith {
    switch (_action) do {
        case "apply": {
            DBG(FORMAT_1("EMP hit player %1",name player));
            if ((_cfg get "gear") == 2) then {[player, _cfg] call FUNC(empFry)};
            GVAR(playerCfg) = _cfg;
            call FUNC(empSuppressLocal);
        };
        case "enforce": {
            GVAR(playerCfg) = _cfg;
        };
        default {
            DBG(FORMAT_1("EMP released player %1",name player));
            GVAR(playerCfg) = nil;
        };
    };
};

// AI
if (_entity isKindOf "CAManBase") exitWith {
    switch (_action) do {
        case "apply": {
            if !(_cfg get "ai") exitWith {};
            private _saved = [hmd _entity, _entity isFlashlightOn (currentWeapon _entity), _entity isIRLaserOn (currentWeapon _entity), false];
            if ((_cfg get "gear") > 0 && {(_saved select 0) isNotEqualTo ""} && {[_saved select 0, _cfg] call FUNC(empIsElectronic)}) then {
                _entity unassignItem (_saved select 0);
                if ((_cfg get "gear") == 2) then {
                    [QGVAR(sparks), [_entity, false, 0.9]] call CBA_fnc_globalEvent;
                    _entity removeItem (_saved select 0);
                    private _pointer = (primaryWeaponItems _entity) param [1, ""];
                    if (_pointer isNotEqualTo "") then {_entity removePrimaryWeaponItem _pointer};
                    _saved set [3, true];
                };
            };
            _entity enableGunLights "ForceOff";
            _entity enableIRLasers false;
            _entity setVariable [QGVAR(saved), _saved];
        };
        case "enforce": {};
        default {
            private _saved = _entity getVariable [QGVAR(saved), []];
            if (_saved isEqualTo []) exitWith {};
            _entity setVariable [QGVAR(saved), nil];
            _saved params ["_hmd", "_light", "_laser", "_fried"];
            if (!_fried && _hmd isNotEqualTo "" && {hmd _entity isEqualTo ""} && {_hmd in items _entity}) then {
                _entity assignItem _hmd;
            };
            _entity enableGunLights (["Auto", "ForceOn"] select _light);
            _entity enableIRLasers _laser;
        };
    };
};

// Vehicle
private _mode = switch (true) do {
    case (unitIsUAV _entity): {[0, 0, 1] select (_cfg getOrDefault ["uavs", 0])};
    case (_entity isKindOf "Air"): {_cfg getOrDefault ["aircraft", 0]};
    default {_cfg getOrDefault ["vehicles", 0]};
};
private _immune = ((_cfg getOrDefault ["vehiclesImmune", ""]) splitString ",") apply {trim _x};
if (_immune findIf {_x isNotEqualTo "" && {_entity isKindOf _x}} != -1) then {_mode = 0};

switch (_action) do {
    case "apply": {
        if (_mode == 0) exitWith {};
        DBG(FORMAT_3("EMP hit vehicle %1 at %2, mode %3",typeOf _entity,mapGridPosition _entity,_mode));
        _entity engineOn false;
        _entity setPilotLight false;
        _entity setCollisionLight false;
        _entity disableTIEquipment true;
        _entity disableNVGEquipment true;
        // Engine hitpoints wrecked while knocked out; first hit saves their damage
        // and drains fuel, a vehicle hit again (new owner) keeps the saved values.
        private _engines = ((getAllHitPointsDamage _entity) param [0, []]) select {"engine" in toLowerANSI _x};
        if (isNil {_entity getVariable QGVAR(savedEngine)}) then {
            _entity setVariable [QGVAR(savedEngine), _engines apply {[_x, _entity getHitPointDamage _x]}, true];
            _entity setFuel ((fuel _entity * (1 - (_cfg getOrDefault ["fuelDrain", 0]))) max 0);
        };
        {_entity setHitPointDamage [_x, 1, false]} forEach _engines;
        _entity setVariable [QGVAR(dead), true, true];
        _entity setVariable [QGVAR(fried), _mode == 2, true];
        if (_mode == 2) then {
            [QGVAR(sparks), [_entity, true, 0.6]] call CBA_fnc_globalEvent;
            [{[QGVAR(sparks), [_this select 0, random 1 < 0.5, 0.4]] call CBA_fnc_globalEvent}, [_entity], 0.3 + random 0.5] call CBA_fnc_waitAndExecute;
            {
                private _name = toLowerANSI _x;
                if (["engine", "avionics", "light", "batter", "elec"] findIf {_x in _name} != -1) then {
                    _entity setHitPointDamage [_x, 1];
                };
            } forEach ((getAllHitPointsDamage _entity) param [0, []]);
        };
    };
    case "enforce": {
        if !(_entity getVariable [QGVAR(dead), false]) exitWith {};
        if (isEngineOn _entity) then {_entity engineOn false};
        {
            _x params ["_hitPoint"];
            if ((_entity getHitPointDamage _hitPoint) < 1) then {_entity setHitPointDamage [_hitPoint, 1, false]};
        } forEach (_entity getVariable [QGVAR(savedEngine), []]);
        if (isLightOn _entity) then {_entity setPilotLight false};
        if (isCollisionLightOn _entity) then {_entity setCollisionLight false};
    };
    default {
        if !(_entity getVariable [QGVAR(dead), false]) exitWith {};
        private _saved = _entity getVariable [QGVAR(savedEngine), []];
        _entity setVariable [QGVAR(savedEngine), nil, true];
        if (_entity getVariable [QGVAR(fried), false]) exitWith {};
        {_entity setHitPointDamage [_x select 0, _x select 1, false]} forEach _saved;
        _entity disableTIEquipment false;
        _entity disableNVGEquipment false;
        _entity setVariable [QGVAR(dead), false, true];
        DBG(FORMAT_2("EMP released vehicle %1 at %2",typeOf _entity,mapGridPosition _entity));
    };
};
