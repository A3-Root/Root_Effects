#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs an acid rain zone on the server: creates the anchor, broadcasts the
 * downpour to all clients (JIP safe) and, when damage is on, slowly eats away at
 * everything left out in it. Units in the open take burn damage, vehicles corrode
 * hitpoint by hitpoint, and buildings, walls and props weather down towards a cap
 * (1 lets them collapse). Anything under a roof, wearing protective gear, of a
 * protected vehicle or building class, or inside a safe zone is spared. With
 * weather rain on, the server also pulls in heavy cloud and real rain for the
 * duration and eases the old weather back afterwards.
 *
 * Arguments:
 * 0: Center position ATL <ARRAY>
 * 1: Zone radius in meters <NUMBER>
 * 2: Screen tint strength 0..1 <NUMBER>
 * 3: Apply damage <BOOL>
 * 4: Unit damage per tick <NUMBER>
 * 5: Seconds between damage ticks <NUMBER>
 * 6: Rain intensity 0.1 - 1 <NUMBER>
 * 7: Also drive the real weather rain <BOOL>
 * 8: Vehicle damage per tick <NUMBER>
 * 9: Building damage per tick <NUMBER>
 * 10: Building damage cap 0..1 <NUMBER>
 * 11: Protective gear classes, comma separated <STRING>
 * 12: Protected vehicle classes, comma separated <STRING>
 * 13: Protected building classes, comma separated <STRING>
 * 14: Safe zones: marker or trigger names, comma separated <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 500, 0.5, true, 0.05, 5, 0.7, true, 0.02, 0.01, 0.9, "H_PilotHelmetFighter_B", "", "", "safe_1"] call root_effects_weather_fnc_acidRainStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 500, [0]],
    ["_tint", 0.5, [0]],
    ["_damage", true, [false]],
    ["_damagePerTick", 0.05, [0]],
    ["_tick", 5, [0]],
    ["_intensity", 0.7, [0]],
    ["_weatherRain", false, [false]],
    ["_vehicleRate", 0.02, [0]],
    ["_buildingRate", 0.01, [0]],
    ["_buildingCap", 0.9, [0]],
    ["_safeGear", "", [""]],
    ["_safeVehicles", "", [""]],
    ["_safeBuildings", "", [""]],
    ["_safeAreas", "", [""]]
];

DBG(FORMAT_1("acidRainStart called with %1",_this));

if (!isServer) exitWith {};
if (!(["acidrain"] call EFUNC(main,isEffectEnabled))) exitWith {
    DBG("acid rain rejected, effect disabled");
};

_tick = _tick max 1;
_damage = _damage && GVAR(allowDamage);
_buildingCap = (_buildingCap max 0) min 1;

private _fnc_csv = {
    params ["_csv"];
    ((_csv splitString ",") apply {trim _x}) select {_x isNotEqualTo ""}
};
private _safety = [
    [_safeGear] call _fnc_csv,
    [_safeVehicles] call _fnc_csv,
    [_safeBuildings] call _fnc_csv,
    [_safeAreas] call _fnc_csv
];

private _anchor = ["acidrain", QGVAR(acidRainLocal), [_radius, _tint, _intensity, _weatherRain], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// Real rain (and the cloud it needs) for the whole storm, restored afterwards.
if (_weatherRain) then {
    private _prevWeather = [overcast, rain];
    _anchor setVariable [QGVAR(prevWeather), _prevWeather];
    0 setOvercast (overcast max (0.75 + 0.2 * _intensity));
    forceWeatherChange;
    [{
        params ["_intensity"];
        20 setRain (0.4 + 0.6 * _intensity);
    }, [_intensity], 1] call CBA_fnc_waitAndExecute;

    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_prevWeather"];
        if (!isNull _anchor) exitWith {};
        _prevWeather params ["_overcast", "_rain"];
        60 setOvercast _overcast;
        60 setRain _rain;
        DBG("acid rain ended, weather eased back");
        _handle call CBA_fnc_removePerFrameHandler;
    }, 2, [_anchor, _prevWeather]] call CBA_fnc_addPerFrameHandler;
};

if (_damage) then {
    // Structures are gathered once and worked through a slice per tick, so a big
    // zone over a town never stalls the server.
    private _structures = nearestTerrainObjects [_pos, ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "LIGHTHOUSE", "WATERTOWER", "WALL", "FENCE", "POWER LINES", "TRANSMITTER"], _radius, false, true];
    _structures append (nearestObjects [_pos, ["Building", "House", "Wall", "Thing", "ThingX", "ReammoBox_F"], _radius, true]);
    _structures = _structures arrayIntersect _structures;
    DBG(FORMAT_2("acid rain will weather %1 structures within %2 m",count _structures,_radius));

    [{
        params ["_args", "_handle"];
        _args params ["_anchor", "_radius", "_unitRate", "_vehicleRate", "_buildingRate", "_buildingCap", "_safety", "_structures", "_cursor"];

        if (isNull _anchor) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _center = getPosATL _anchor;
        private _burned = 0;
        private _corroded = 0;

        // People out in the open.
        if (_unitRate > 0) then {
            {
                private _unit = _x;
                if (!(_unit isKindOf "VirtualMan_F") && {isNull objectParent _unit} && {!([_unit, _safety] call FUNC(acidIsSafe))}) then {
                    [_unit, _unitRate, selectRandom ["Body", "Head", "LeftArm", "RightArm"], "burn", _anchor] call EFUNC(main,doDamage);
                    _burned = _burned + 1;
                };
            } forEach (_center nearEntities [["CAManBase"], _radius]);
        };

        // Vehicles left outside corrode; their crews stay dry inside.
        if (_vehicleRate > 0) then {
            {
                private _vehicle = _x;
                if (alive _vehicle && {!([_vehicle, _safety] call FUNC(acidIsSafe))}) then {
                    [_vehicle, _vehicleRate, true] call EFUNC(main,doHitPointDamage);
                    [_vehicle, _vehicleRate * 0.3, "Body", "burn", _anchor] call EFUNC(main,doDamage);
                    _corroded = _corroded + 1;
                };
            } forEach (_center nearEntities [["LandVehicle", "Air", "Ship", "StaticWeapon"], _radius]);
        };

        // A slice of the structures weathers each tick.
        if (_buildingRate > 0 && {_structures isNotEqualTo []}) then {
            private _count = count _structures;
            private _slice = 150 min _count;
            for "_i" from 0 to (_slice - 1) do {
                private _object = _structures select ((_cursor + _i) mod _count);
                if (!isNull _object && {alive _object} && {(damage _object) < _buildingCap} && {!([_object, _safety] call FUNC(acidIsSafe))}) then {
                    // Each slice comes round once per lap, so it takes a full lap's worth.
                    private _step = _buildingRate * ((_count / _slice) max 1);
                    // At a cap of 1 the structure is finally destroyed and collapses.
                    _object setDamage (((damage _object) + _step) min _buildingCap);
                };
            };
            _args set [8, (_cursor + _slice) mod _count];
        };

        if (_burned + _corroded > 0) then {
            DBG(FORMAT_3("acid rain tick at %1: %2 units burned, %3 vehicles corroded",mapGridPosition _center,_burned,_corroded));
        };
    }, _tick, [_anchor, _radius, _damagePerTick, _vehicleRate, _buildingRate, _buildingCap, _safety, _structures, 0]] call CBA_fnc_addPerFrameHandler;
};

DBG(FORMAT_4("acid rain started at %1, radius %2, damage %3, safe zones %4",mapGridPosition _pos,_radius,_damage,_safeAreas));
