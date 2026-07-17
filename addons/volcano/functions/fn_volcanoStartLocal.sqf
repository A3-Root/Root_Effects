#include "..\script_component.hpp"

/*
 * Author: Root, based on work by Aliascartoons
 * Client side visuals for one volcano instance. Runs a slow watcher loop that
 * creates the local particle emitters and lights while the player is within
 * effect view distance, tears them down when the player leaves the area and
 * ends itself once the instance anchor is deleted. Also plays the ambient
 * crater murmur.
 *
 * Arguments:
 * 0: Instance anchor <OBJECT>
 * 1: Crater radius in meters <NUMBER>
 * 2: Enable crater lava visuals <BOOL>
 * 3: Enable lava flow visuals <BOOL>
 * 4: Enable ash cloud lightning <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_anchor, 120, true, false, true] call root_effects_volcano_fnc_volcanoStartLocal
 */

params [["_anchor", objNull, [objNull]], ["_radius", 120, [0]], ["_craterLava", false, [false]], ["_lavaFlow", false, [false]], ["_lightning", false, [false]]];

if (!hasInterface) exitWith {};
if (isNull _anchor) exitWith {};

// [anchor, radius, craterLava, lavaFlow, lightning, visuals, flickerId, nextMurmurTime]
private _state = [_anchor, _radius, _craterLava, _lavaFlow, _lightning, [], -1, 0];

[{
    params ["_args", "_handle"];
    _args params ["_anchor", "_radius", "_craterLava", "_lavaFlow", "_lightning", "_visuals", "_flickerId", "_nextMurmur"];

    if (isNull _anchor) exitWith {
        {
            deleteVehicle _x;
        } forEach _visuals;
        if (_flickerId != -1) then {
            _flickerId call CBA_fnc_removePerFrameHandler;
        };
        _handle call CBA_fnc_removePerFrameHandler;
    };

    // A volcano is a landmark, so render it further out than small effects.
    private _viewDistance = (EGVAR(main,maxViewDistance)) max 2000;
    private _inRange = (player distance2D _anchor) < _viewDistance;

    if (_inRange && {_visuals isEqualTo []}) then {
        private _budget = (EGVAR(main,particleBudget)) max 0.1;
        private _pos = getPosATL _anchor;

        // Glowing crater core light with a flicker loop.
        private _craterLight = "#lightpoint" createVehicleLocal _pos;
        _craterLight lightAttachObject [_anchor, [0, 0, 50]];
        _craterLight setLightAttenuation [0, 0, 0, 0, 40, 1000];
        _craterLight setLightIntensity 1500;
        _craterLight setLightBrightness 30;
        _craterLight setLightDayLight true;
        _craterLight setLightUseFlare true;
        _craterLight setLightFlareSize 0;
        _craterLight setLightFlareMaxDistance 2000;
        _craterLight setLightAmbient [1, 0.2, 0.1];
        _craterLight setLightColor [1, 0.2, 0.1];
        _visuals pushBack _craterLight;

        private _newFlickerId = [{
            params ["_flickerArgs"];
            _flickerArgs params ["_light"];
            _light setLightBrightness (59 + random 40);
            _light setLightAttenuation [1.5 + random 0.5, 90 + random 10, 290 + random 10, 1, 150 + random 100, 1500];
        }, 0.1, [_craterLight]] call CBA_fnc_addPerFrameHandler;
        _args set [6, _newFlickerId];

        // Permanent ash column; the per particle callback spawns the big
        // drifting clouds (and lightning when enabled).
        private _columnScript = [QPATHTOF(functions\fn_volcanoSmokeColumn.sqf), QPATHTOF(functions\fn_volcanoSmokeColumnLightning.sqf)] select _lightning;
        private _smokeColumn = "#particlesource" createVehicleLocal _pos;
        _smokeColumn setParticleCircle [0, [0, 0, 0]];
        _smokeColumn setParticleRandom [7, [30, 30, 20], [10, 10, 15], 0, 0.5, [0, 0, 0, 0.1], 1, 0];
        _smokeColumn setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 20, [0, 0, 30], [0, 0, 45], 0, 3, 2, 0, [50, 100, 100], [[0, 0, 0, 0.5], [1, 1, 1, 0.5], [0.5, 0.5, 0.5, 0]], [0.5], 0.5, 0, "", _columnScript, _anchor];
        _smokeColumn setDropInterval (0.05 / _budget);
        _visuals pushBack _smokeColumn;

        if (_craterLava) then {
            private _interiorLava = "#particlesource" createVehicleLocal _pos;
            _interiorLava setParticleCircle [0, [0, 0, 0]];
            _interiorLava setParticleRandom [3, [_radius, _radius, 10], [0, 0, 0], 5, 0.2, [0, 0, 0, 0.1], 1, 0];
            _interiorLava setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 20, [0, 0, 30], [0, 0, 0], 3, 10.05, 7.9, 0, [_radius * 2, _radius * 2 + 10, _radius * 2], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _anchor];
            _interiorLava setDropInterval (0.1 / _budget);
            _visuals pushBack _interiorLava;

            private _lavaHeat = "#particlesource" createVehicleLocal _pos;
            _lavaHeat setParticleCircle [0, [0, 0, 0]];
            _lavaHeat setParticleRandom [5, [_radius, _radius, 10], [0, 0, 0], 5, 0.2, [0, 0, 0, 0.1], 1, 0];
            _lavaHeat setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1, 20, [0, 0, 30], [0, 0, 0], 5, 9.5, 7.9, 0.5, [_radius * 3, _radius * 2, _radius], [[1, 1, 1, 0], [1, 1, 1, 1], [1, 1, 1, 0]], [1], 1, 0, "", "", _anchor];
            _lavaHeat setDropInterval (0.1 / _budget);
            _visuals pushBack _lavaHeat;

            private _lavaGlow = "#particlesource" createVehicleLocal _pos;
            _lavaGlow setParticleCircle [_radius / 2, [0, 0, 0]];
            _lavaGlow setParticleRandom [5, [_radius / 4, _radius / 4, 5], [0, 0, 0], 0, 0.1, [0, 0, 0, 0], 0, 0];
            _lavaGlow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 0], "", "BillBoard", 1, 10, [0, 0, 0], [0, 0, 30], 0, 80, 7, 0, [_radius, _radius * 5 + 20], [[1, 0.7, 0, 1], [0, 0, 0, 0]], [1], 1, 0, "", "", _anchor];
            _lavaGlow setDropInterval (0.7 / _budget);
            _visuals pushBack _lavaGlow;

            private _lavaChunks = "#particlesource" createVehicleLocal _pos;
            _lavaChunks setParticleCircle [_radius, [0, 0, 0]];
            _lavaChunks setParticleRandom [5, [_radius / 6, _radius / 6, 50], [15, 15, 20], 0, 0.1, [0, 0, 0, 1], 1, 1];
            _lavaChunks setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 30], [0, 0, 50], 0, 30, 6, 0, [4, 0.1], [[1, 1, 1, 1], [1, 1, 1, 1]], [1], 1, 1, "", "", _anchor];
            _lavaChunks setDropInterval (0.2 / _budget);
            _visuals pushBack _lavaChunks;

            private _lavaBoil = "#particlesource" createVehicleLocal _pos;
            _lavaBoil setParticleCircle [_radius / 3, [0, 0, 0]];
            _lavaBoil setParticleRandom [0, [_radius / 6, _radius / 6, 0], [0.5, 0.5, 20], 0, 0.5, [0, 0, 0, 0.1], 1, 0];
            _lavaBoil setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, 20], 0, 70, 6, 0, [_radius, _radius + 5, _radius * 2], [[1, 0.1, 0.1, 0.5], [1, 0.5, 0.1, 0.3], [1, 0.5, 0, 0]], [1], 1, 0, "", "", _anchor];
            _lavaBoil setDropInterval (0.3 / _budget);
            _visuals pushBack _lavaBoil;
        };

        if (_lavaFlow) then {
            // Three glowing streams running downhill from the crater rim.
            for "_i" from 0 to 2 do {
                private _rimDir = random 360;
                private _rimPos = _pos getPos [_radius * 0.8, _rimDir];
                _rimPos set [2, 0];

                private _downhill = surfaceNormal _rimPos;
                private _flowVelocity = [(_downhill select 0) * 3, (_downhill select 1) * 3, -1];

                private _lavaStream = "#particlesource" createVehicleLocal _rimPos;
                _lavaStream setParticleCircle [20, [0, 0, 0]];
                _lavaStream setParticleRandom [5, [5, 40, 0], [0, 0, 0], 1, 0.2, [0, 0, 0, 0.1], 1, 0];
                _lavaStream setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 10, 32, 1], "", "Billboard", 1, 30, [0, 0, 0], _flowVelocity, 1, 10, 7.9, 0, [5, 5, 10], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.5], 1, 0, "", "", _anchor];
                _lavaStream setDropInterval (0.1 / _budget);
                _lavaStream setParticleFire [1, 50, 0.1];
                _visuals pushBack _lavaStream;

                // Each stream carries its own glow, which is what sells molten
                // rock after dark; in daylight it barely registers.
                private _streamGlow = "#lightpoint" createVehicleLocal (_rimPos vectorAdd [0, 0, 3]);
                _streamGlow setLightBrightness ([1.5, 5] select (sunOrMoon < 0.4));
                _streamGlow setLightColor [1, 0.35, 0.05];
                _streamGlow setLightAmbient [1, 0.35, 0.05];
                _streamGlow setLightAttenuation [3, 0, 60, 0, 15, 90];
                _visuals pushBack _streamGlow;
            };
        };

        // Ash carried off the column and settling downwind of the mountain.
        private _windDir = (wind select 0) atan2 (wind select 1);
        private _windSpeed = (vectorMagnitude wind) max 1;
        private _ashPos = _pos getPos [_radius * 1.5, _windDir];
        _ashPos set [2, 0];

        private _ashFall = "#particlesource" createVehicleLocal _ashPos;
        _ashFall setParticleCircle [_radius, [0, 0, 0]];
        _ashFall setParticleRandom [8, [_radius, _radius, 30], [2, 2, 0.5], 0, 0.5, [0, 0, 0, 0.05], 0, 0];
        _ashFall setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13], "", "Billboard", 1, 20, [0, 0, 80], [(wind select 0) * 0.5, (wind select 1) * 0.5, -1.5], 0, 10, 7.5, 0.02, [1, 4], [[0.3, 0.3, 0.3, 0.35], [0.35, 0.35, 0.35, 0.2], [0.4, 0.4, 0.4, 0]], [0.3, 0.8], 1, 0, "", "", _anchor];
        _ashFall setDropInterval ((0.05 / _windSpeed) / _budget);
        _visuals pushBack _ashFall;

        _args set [5, _visuals];
    };

    if (!_inRange && {_visuals isNotEqualTo []}) then {
        {
            deleteVehicle _x;
        } forEach _visuals;
        _args set [5, []];

        if (_flickerId != -1) then {
            _flickerId call CBA_fnc_removePerFrameHandler;
            _args set [6, -1];
        };
    };

    if (_inRange && {CBA_missionTime >= _nextMurmur}) then {
        _anchor say3D [QGVAR(murmur), 5000];
        _args set [7, CBA_missionTime + 60];
    };
}, 1, _state] call CBA_fnc_addPerFrameHandler;
