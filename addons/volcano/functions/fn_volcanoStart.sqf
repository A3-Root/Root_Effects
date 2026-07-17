#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Starts a volcano instance on the server: creates the anchor, broadcasts the
 * visual setup to all clients (JIP safe), schedules recurring eruptions and
 * runs the optional lethality loop around the module position. Multiple
 * instances can run at the same time; all state lives on the anchor.
 *
 * Arguments:
 * 0: Position ATL of the crater center <ARRAY>
 * 1: Crater radius in meters <NUMBER>
 * 2: Delay between eruptions in seconds, 0 disables eruptions <NUMBER>
 * 3: Enable crater lava visuals <BOOL>
 * 4: Enable ash cloud lightning <BOOL>
 * 5: Enable lava flow visuals <BOOL>
 * 6: Kill unprotected units near the crater <BOOL>
 * 7: Comma separated protective gear class names <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 120, 300, true, true, false, true, ""] call root_effects_volcano_fnc_volcanoStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 120, [0]],
    ["_eruptionDelay", 0, [0]],
    ["_craterLava", false, [false]],
    ["_lightning", false, [false]],
    ["_lavaFlow", false, [false]],
    ["_lethal", true, [false]],
    ["_gearText", "", [""]]
];

if (!isServer) exitWith {};
if (!(["volcano"] call EFUNC(main,isEffectEnabled))) exitWith {};

_radius = _radius max 10;

// Protective gear arrives as free text; normalize it into class names.
private _gear = (_gearText splitString ", ") select {_x isNotEqualTo ""};

private _anchor = ["volcano", QGVAR(startLocal), [_radius, _craterLava, _lavaFlow, _lightning], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

_anchor setVariable [QGVAR(gear), _gear];

if (_eruptionDelay > 0) then {
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_radius"];

        if (isNull _anchor) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _soundSet = selectRandom [
            [QGVAR(eruption_1), 10, QGVAR(eruption_1_echo)],
            [QGVAR(eruption_2), 4, QGVAR(eruption_2_echo)],
            [QGVAR(eruption_3), 19, QGVAR(eruption_3_echo)]
        ];
        private _burstType = selectRandom ["sparks", "shrapnel", "puff"];

        [QGVAR(burst), [_anchor, _radius, _burstType] + _soundSet] call CBA_fnc_globalEvent;
    }, _eruptionDelay, [_anchor, _radius]] call CBA_fnc_addPerFrameHandler;
};

if (_lethal && GVAR(allowLethality)) then {
    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_radius"];

        if (isNull _anchor) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _gear = _anchor getVariable [QGVAR(gear), []];
        private _lethalRadius = _radius * 2;

        {
            private _target = _x;
            if (!(_target isKindOf "VirtualMan_F")) then {
                private _distance = _target distance2D _anchor;
                private _insideCrater = _distance <= _radius;
                private _isInfantry = _target isKindOf "CAManBase";
                private _protected = _isInfantry && {[_target, _gear] call FUNC(volcanoIsProtected)};

                if (_insideCrater || {!_protected}) then {
                    // The crater itself is not survivable; past its lip the
                    // heat falls off with distance, so protective gear and a
                    // vehicle hull buy real time out on the slopes.
                    private _amount = 1;
                    if (!_insideCrater) then {
                        _amount = linearConversion [_radius, _lethalRadius, _distance, 1, 0.15, true];
                    };

                    if (_isInfantry) then {
                        [_target, _amount, "Body", "burn", _anchor] call EFUNC(main,doDamage);
                    } else {
                        [_target, _amount] call EFUNC(main,doDamage);
                    };
                };
            };
        } forEach (_anchor nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"], _lethalRadius]);
    }, 2, [_anchor, _radius]] call CBA_fnc_addPerFrameHandler;
};

DBG(FORMAT_2("volcano started, radius %1, eruption delay %2",_radius,_eruptionDelay));
