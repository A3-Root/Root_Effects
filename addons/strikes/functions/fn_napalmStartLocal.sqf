#include "..\script_component.hpp"

/*
 * Author: Root
 * Client side fire wall for one napalm strike: fire and smoke emitters with
 * glow lights along the strike line. A slow watcher loop creates the wall in
 * view range, removes it out of range and ends itself once the anchor is
 * deleted.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Attack heading in degrees <NUMBER>
 * 2: Fire line length in meters <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 0, 150] call root_effects_strikes_fnc_napalmStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_heading", 0, [0]], ["_length", 150, [0]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, heading, length, visuals]
private _state = [_anchor, _heading, _length, []];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_heading", "_length", "_visuals"];

    if (isNull _anchor) exitWith {
        {
            deleteVehicle _x;
        } forEach _visuals;
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _inRange = (player distance2D _anchor) < EGVAR(main,maxViewDistance);

    if (_inRange && {_visuals isEqualTo []}) then {
        private _budget = (EGVAR(main,particleBudget)) max 0.1;
        private _center = getPosATL _anchor;
        private _spacing = 12;
        private _segments = ceil (_length / _spacing) min 40;

        for "_i" from 0 to (_segments - 1) do {
            private _offset = -_length / 2 + _i * _spacing + random (_spacing / 2);
            private _firePos = _center getPos [abs _offset, [_heading + 180, _heading] select (_offset >= 0)];
            _firePos set [2, 0];

            private _fire = "#particlesource" createVehicleLocal _firePos;
            _fire setParticleClass "MediumDestructionFire";
            _fire setDropInterval (0.05 / _budget);
            _visuals pushBack _fire;

            private _smoke = "#particlesource" createVehicleLocal _firePos;
            _smoke setParticleClass "BigDestructionSmoke";
            _smoke setDropInterval (0.2 / _budget);
            _visuals pushBack _smoke;

            if (_i mod 3 == 0) then {
                private _glow = "#lightpoint" createVehicleLocal (_firePos vectorAdd [0, 0, 2]);
                _glow setLightBrightness 2;
                _glow setLightColor [1, 0.45, 0.1];
                _glow setLightAmbient [1, 0.45, 0.1];
                _glow setLightAttenuation [2, 0, 40, 0, 10, 60];
                _visuals pushBack _glow;
            };
        };

        _args set [3, _visuals];
    };

    if (!_inRange && {_visuals isNotEqualTo []}) then {
        {
            deleteVehicle _x;
        } forEach _visuals;
        _args set [3, []];
    };
}, 1, _state] call CBA_fnc_addPerFrameHandler;
