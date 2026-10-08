#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs a scree avalanche on the server: creates the anchor, broadcasts the
 * dust and scree cascade to all clients (JIP safe) and releases real physics
 * boulders down the corridor that crush and shove whatever they hit when the
 * slide is lethal. The instance removes itself once the slide has run out.
 *
 * Arguments:
 * 0: Head position ATL of the slide <ARRAY>
 * 1: Travel heading in degrees, -1 to follow the slope downhill <NUMBER>
 * 2: Slide length in meters <NUMBER>
 * 3: Slide duration in seconds <NUMBER>
 * 4: Crush units caught in the corridor <BOOL>
 * 5: Comma separated vehicle classes to roll down the slope, "" for none <STRING>
 * 6: Number of physical boulders released down the slope <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], -1, 200, 25, true, "Land_MetalBarrel_F", 40] call root_effects_volcano_fnc_avalancheStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_heading", -1, [0]],
    ["_length", 200, [0]],
    ["_duration", 25, [0]],
    ["_lethal", true, [false]],
    ["_objects", "", [""]],
    ["_rockCount", 40, [0]]
];

DBG(FORMAT_1("avalancheStart called with %1",_this));

if (!isServer) exitWith {};
if (!(["avalanche"] call EFUNC(main,isEffectEnabled))) exitWith {};

_length = (_length max 50) min 800;
_duration = _duration max 10;
_lethal = _lethal && GVAR(allowLethality);

// Rock runs downhill unless the curator forced a direction. The surface normal
// leans away from the slope, so its horizontal part points down it.
if (_heading < 0) then {
    private _normal = surfaceNormal _pos;
    private _flat = [_normal select 0, _normal select 1];

    _heading = if ((vectorMagnitude _flat) < 0.01) then {
        // Flat ground gives no downhill; fall back to a random direction.
        random 360
    } else {
        (_normal select 0) atan2 (_normal select 1)
    };
};

_rockCount = round ((_rockCount max 0) min 80);

private _anchor = ["avalanche", QGVAR(avalancheLocal), [_heading, _length, _duration], _pos] call EFUNC(main,startEffect);
if (isNull _anchor) exitWith {};

// Real physics boulders, plus any custom classes the curator named, roll down the
// corridor and do the damage on contact; the moving front crushes what it covers.
private _classes = (_objects splitString ",") apply {trim _x};
private _unknown = _classes select {_x isNotEqualTo "" && {!isClass (configFile >> "CfgVehicles" >> _x)}};
if (_unknown isNotEqualTo []) then {
    DBG(FORMAT_1("avalanche ignoring unknown classes %1",_unknown));
};
_classes = _classes select {_x isNotEqualTo "" && {isClass (configFile >> "CfgVehicles" >> _x)}};
[_anchor, _heading, _length, _duration, _rockCount, _classes, _lethal] call FUNC(avalancheRocks);

// Debris lingers a little after the dust settles before the instance ends.
[{
    params ["_anchor"];
    ["avalanche", _anchor] call EFUNC(main,stopEffect);
}, [_anchor], _duration + 25] call CBA_fnc_waitAndExecute;

DBG(FORMAT_4("avalanche started at %1, heading %2, length %3, boulders %4",mapGridPosition _pos,round _heading,_length,_rockCount));
