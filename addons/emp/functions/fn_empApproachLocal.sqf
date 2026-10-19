#include "..\script_component.hpp"

/*
 * Author: Root
 * Player approach warning, every 0.2 s while fields exist: the HUD blinks out and
 * the screen crackles when nearing a field (ground / helicopter / plane warning
 * range by what the player sits in), more often the closer, and constantly during
 * the grace time inside. HUD and screen are put back once clear.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call root_effects_emp_fnc_empApproachLocal
 */

if (!hasInterface) exitWith {};
if (GVAR(approachHandle) >= 0) exitWith {};

// [saved HUD, grain handle, next crackle]
GVAR(approachHandle) = [{
    params ["_args", "_handle"];
    _args params ["_savedHud", "_grain", "_nextCrackle"];

    private _fnc_clear = {
        if (_savedHud isNotEqualTo []) then {
            showHUD _savedHud;
            _args set [0, []];
        };
        if (_grain >= 0) then {
            ppEffectDestroy _grain;
            _args set [1, -1];
        };
    };

    if (GVAR(fields) isEqualTo []) exitWith {
        call _fnc_clear;
        GVAR(approachHandle) = -1;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // Strength 0..1: grace time inside counts as full.
    private _strength = 0;
    if (CBA_missionTime < (missionNamespace getVariable [QGVAR(warnUntil), -1])) then {
        _strength = 1;
    } else {
        if (!isNil QGVAR(playerCfg) || {!alive player}) exitWith {};
        private _vehicle = vehicle player;
        private _key = switch (true) do {
            case (_vehicle isKindOf "Plane"): {"warnPlane"};
            case (_vehicle isKindOf "Helicopter"): {"warnHeli"};
            default {"warnGround"};
        };
        private _pos = getPosASL _vehicle;
        {
            private _range = (_x select 1) getOrDefault [_key, 0];
            if (_range > 0) then {
                private _distance = [_pos, _x] call FUNC(empBoundaryDist);
                if (_distance > 0 && _distance < _range) then {
                    _strength = _strength max (1 - _distance / _range);
                };
            };
        } forEach GVAR(fields);
    };

    if (_strength <= 0) exitWith {call _fnc_clear};

    if (_savedHud isEqualTo []) then {
        _savedHud = shownHUD;
        _args set [0, _savedHud];
    };
    if (random 1 < 0.2 + 0.6 * _strength) then {
        showHUD [false, false, false, false, false, false, false, false, false, false];
    } else {
        showHUD _savedHud;
    };

    if (_grain < 0) then {
        _grain = ppEffectCreate ["FilmGrain", 2012];
        _grain ppEffectEnable true;
        _args set [1, _grain];
    };
    _grain ppEffectAdjust [_strength * (0.05 + random 0.25), 1, 1.5, 0.3, 1, false];
    _grain ppEffectCommit 0.1;

    if (CBA_missionTime >= _nextCrackle) then {
        _args set [2, CBA_missionTime + 4 - 3 * _strength + random 1];
        playSound3D ["a3\sounds_f\weapons\mines\electron_activate_mine_1.wss", objNull, false, getPosASL player, 0.5 + _strength, 1.5, 20];
    };
}, 0.2, [[], -1, 0]] call CBA_fnc_addPerFrameHandler;
