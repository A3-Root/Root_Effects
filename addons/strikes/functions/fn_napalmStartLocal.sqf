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
        private _spacing = 9;
        private _segments = ceil (_length / _spacing) min 50;
        // Unit vector across the attack line, used to give the flames width so
        // the corridor reads as a body of fire rather than a flat edge-on sheet.
        private _perp = [sin (_heading + 90), cos (_heading + 90), 0];

        for "_i" from 0 to (_segments - 1) do {
            private _offset = -_length / 2 + _i * _spacing + random (_spacing / 2);
            private _firePos = _center getPos [abs _offset, [_heading + 180, _heading] select (_offset >= 0)];
            _firePos = _firePos vectorAdd (_perp vectorMultiply ((random 16) - 8));
            _firePos set [2, 0];

            // Tall rolling flame body: the sprite animates through the fire
            // frames of the universal sheet while the colour ramp carries it
            // from white hot at the base to dark smoke at the top.
            private _fire = "#particlesource" createVehicleLocal _firePos;
            _fire setParticleCircle [0, [0, 0, 0]];
            _fire setParticleRandom [0.5, [1.5, 1.5, 0], [1.2, 1.2, 1.5], 0, 0.4, [0, 0, 0, 0.1], 0, 0];
            _fire setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 2, 32], "", "Billboard", 1, 2, [0, 0, 0.4], [0, 0, 2.5], 0, 10, 7.9, 0.075, [2.5, 5, 3], [[1, 1, 0.6, 0.9], [1, 0.5, 0.1, 0.75], [0.6, 0.2, 0.05, 0.4], [0.15, 0.15, 0.15, 0]], [0.25, 0.5, 0.75], 1, 0, "", "", _firePos];
            _fire setDropInterval (0.03 / _budget);
            _visuals pushBack _fire;

            private _smoke = "#particlesource" createVehicleLocal _firePos;
            _smoke setParticleClass "BigDestructionSmoke";
            _smoke setDropInterval (0.12 / _budget);
            _visuals pushBack _smoke;

            if (_i mod 2 == 0) then {
                // Embers lifting off the fire on the thermal.
                private _embers = "#particlesource" createVehicleLocal _firePos;
                _embers setParticleCircle [1.5, [0, 0, 0]];
                _embers setParticleRandom [1.5, [2, 2, 0.5], [1.5, 1.5, 2], 0, 0.05, [0, 0, 0, 0.2], 0, 0];
                _embers setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 4, [0, 0, 1], [0, 0, 3.5], 0, 10, 7.9, 0.05, [0.12, 0.06], [[1, 0.9, 0.5, 1], [1, 0.45, 0.1, 0.8], [0.6, 0.15, 0.05, 0]], [0.3, 0.6], 1, 0, "", "", _firePos];
                _embers setDropInterval (0.15 / _budget);
                _visuals pushBack _embers;

                private _glow = "#lightpoint" createVehicleLocal (_firePos vectorAdd [0, 0, 2]);
                _glow setLightBrightness 3;
                _glow setLightColor [1, 0.45, 0.1];
                _glow setLightAmbient [1, 0.45, 0.1];
                _glow setLightAttenuation [2, 0, 40, 0, 10, 60];
                _visuals pushBack _glow;
            };
        };

        // Loose fires scattered across the corridor width fill in the gaps
        // between the main line so the burn looks patchy and three dimensional.
        private _scatterCount = round (_segments / 3);
        for "_j" from 1 to _scatterCount do {
            private _along = (random _length) - _length / 2;
            private _scatterPos = _center getPos [abs _along, [_heading + 180, _heading] select (_along >= 0)];
            _scatterPos = _scatterPos vectorAdd (_perp vectorMultiply ((random 22) - 11));
            _scatterPos set [2, 0];

            private _spot = "#particlesource" createVehicleLocal _scatterPos;
            _spot setParticleCircle [0, [0, 0, 0]];
            _spot setParticleRandom [0.5, [1, 1, 0], [0.8, 0.8, 1.2], 0, 0.4, [0, 0, 0, 0.1], 0, 0];
            _spot setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 2, 32], "", "Billboard", 1, 1.6, [0, 0, 0.3], [0, 0, 1.8], 0, 10, 7.9, 0.075, [1.5, 3, 2], [[1, 1, 0.6, 0.9], [1, 0.5, 0.1, 0.75], [0.6, 0.2, 0.05, 0.4], [0.15, 0.15, 0.15, 0]], [0.25, 0.5, 0.75], 1, 0, "", "", _scatterPos];
            _spot setDropInterval (0.05 / _budget);
            _visuals pushBack _spot;
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
