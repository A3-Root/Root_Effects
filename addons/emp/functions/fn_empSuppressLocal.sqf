#include "..\script_component.hpp"

/*
 * Author: Root
 * Player gear suppression while hit by an EMP field, every 0.1 s, items kept:
 * - goggles forced off, weapon lights and lasers off, electronic binoculars put away,
 * - GPS / sensor info panels off, vehicle sensors off in a knocked out vehicle,
 * - UAV terminal disconnected and closed,
 * - cTab, ACE microDAGR, DAGR, Kestrel and HuntIR displays closed,
 * - optional voice channels off, optional screen interference (heavier in thermal).
 * Runs until GVAR(playerCfg) is cleared, then puts panels, sensors and channels back.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call root_effects_emp_fnc_empSuppressLocal
 */

if (!hasInterface) exitWith {};
if (GVAR(suppressHandle) >= 0) exitWith {};

#define PANEL_TYPES ["MinimapDisplayComponent", "SensorsDisplayComponent", "UAVFeedDisplayComponent", "CrewDisplayComponent", "TransportFeedDisplayComponent", "SlingLoadDisplayComponent", "MineDetectorDisplayComponent", "CustomDisplayComponent"]

// [panels off [target, panel, type], sensors off [vehicle, name], channels [id, state], pp handles, vehicle]
private _state = [[], [], [], [], objNull];

GVAR(suppressHandle) = [{
    params ["_args", "_handle"];
    _args params ["_panels", "_sensors", "_channels", "_pp", "_lastVehicle"];

    private _fnc_restoreVehicle = {
        {
            _x params ["_target", "_panel", "_type"];
            private _object = if (_target isEqualType []) then {_target select 0} else {_target};
            if (!isNull _object) then {_target enableInfoPanelComponent [_panel, _type, true]};
        } forEach _panels;
        _panels resize 0;
        {
            _x params ["_vehicle", "_name"];
            if (!isNull _vehicle) then {_vehicle enableVehicleSensor [_name, true]};
        } forEach _sensors;
        _sensors resize 0;
    };

    if (isNil QGVAR(playerCfg) || {!alive player}) exitWith {
        call _fnc_restoreVehicle;
        {
            _x params ["_id", "_enabled"];
            _id enableChannel _enabled;
        } forEach _channels;
        {ppEffectDestroy _x} forEach _pp;
        GVAR(suppressHandle) = -1;
        _handle call CBA_fnc_removePerFrameHandler;
        DBG("EMP suppression ended");
    };

    private _cfg = GVAR(playerCfg);
    private _gear = _cfg get "gear";
    private _vehicle = vehicle player;

    if (_gear > 0) then {
        // Goggles; vehicle optics are handled by the vehicle knockout.
        if (currentVisionMode player == 1 && {_vehicle isEqualTo player || {cameraView isNotEqualTo "GUNNER"}}) then {
            player action ["nvGogglesOff", player];
        };
        private _weapon = currentWeapon player;
        if (player isFlashlightOn _weapon) then {player action ["GunLightOff", player]};
        if (player isIRLaserOn _weapon) then {player action ["IRLaserOff", player]};
        if (_weapon isNotEqualTo "" && {_weapon isEqualTo binocular player} && {[_weapon, _cfg] call FUNC(empIsElectronic)}) then {
            if (primaryWeapon player isNotEqualTo "") then {
                player selectWeapon primaryWeapon player;
            } else {
                player action ["SwitchWeapon", player, player, -1];
            };
        };

        if (!isNull getConnectedUAV player) then {player connectTerminalToUAV objNull};
        {
            private _display = findDisplay _x;
            if (!isNull _display) then {_display closeDisplay 2};
        } forEach [160, 18880, 18881, 18882, 266860];

        if (!isNil "cTab_fnc_close" && {!isNil {uiNamespace getVariable "cTabIfOpen"}}) then {
            call cTab_fnc_close;
        };
        if ((missionNamespace getVariable ["ace_microdagr_currentShowMode", 0]) != 0) then {
            [0] call ace_microdagr_fnc_openDisplay;
        };
        if (missionNamespace getVariable ["ace_dagr_run", false]) then {ace_dagr_run = false};
        if (missionNamespace getVariable ["ace_kestrel4500_Overlay", false]) then {ace_kestrel4500_Overlay = false};
        if (missionNamespace getVariable ["ace_kestrel4500_Kestrel4500", false]) then {closeDialog 0};

        // Info panels of the player and of a knocked out vehicle, vehicle sensors.
        if (_vehicle isNotEqualTo _lastVehicle) then {
            call _fnc_restoreVehicle;
            _args set [4, _vehicle];
        };
        private _targets = [player];
        if (_vehicle isNotEqualTo player && {_vehicle getVariable [QGVAR(dead), false]}) then {
            _targets pushBack [_vehicle, _vehicle unitTurret player];
            {
                _x params ["_name"];
                if (_sensors findIf {(_x select 1) isEqualTo _name} == -1) then {
                    _vehicle enableVehicleSensor [_name, false];
                    _sensors pushBack [_vehicle, _name];
                };
            } forEach (listVehicleSensors _vehicle);
        };
        {
            private _target = _x;
            {
                private _type = _x;
                {
                    if (_target infoPanelComponentEnabled [_x, _type]) then {
                        _target enableInfoPanelComponent [_x, _type, false];
                        _panels pushBack [_target, _x, _type];
                    };
                } forEach ["left", "right"];
            } forEach PANEL_TYPES;
        } forEach _targets;
    };

    if ((_cfg get "channels") && {_channels isEqualTo []}) then {
        {
            _channels pushBack [_x, channelEnabled _x];
            _x enableChannel [(channelEnabled _x) select 0, false];
        } forEach [1, 2, 3, 4];
    };

    if (_cfg get "hud") then {
        if (_pp isEqualTo []) then {
            private _aberration = ppEffectCreate ["ChromAberration", 210];
            _aberration ppEffectEnable true;
            private _grain = ppEffectCreate ["FilmGrain", 2010];
            _grain ppEffectEnable true;
            _pp append [_aberration, _grain];
        };
        _pp params ["_aberration", "_grain"];
        // Thermal sights have no off switch, so they drown in noise instead.
        private _strength = [0.35, 1] select (currentVisionMode player == 2);
        private _jolt = _strength * (0.005 + random 0.03);
        _aberration ppEffectAdjust [_jolt, _jolt, true];
        _aberration ppEffectCommit 0.1;
        _grain ppEffectAdjust [_strength * (0.15 + random 0.35), 1, 1.5, 0.3, 1, false];
        _grain ppEffectCommit 0.1;
    } else {
        {ppEffectDestroy _x} forEach _pp;
        _pp resize 0;
    };
}, 0.1, _state] call CBA_fnc_addPerFrameHandler;

DBG("EMP suppression started");
