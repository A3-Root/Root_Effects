#include "..\script_component.hpp"

/*
 * Author: Root
 * Runs an area flash freeze on the server: broadcasts the shock front to all
 * clients and locks every unit inside the radius in place for the duration.
 * Units in the inner core also take cold damage. Survivors thaw on their own
 * once the duration runs out.
 *
 * Arguments:
 * 0: Blast center position ATL <ARRAY>
 * 1: Blast radius in meters <NUMBER>
 * 2: Seconds the units stay frozen <NUMBER>
 * 3: Units in the inner core take cold damage <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[1000, 2000, 0], 80, 30, true] call root_effects_freeze_fnc_cryoBlastStart
 */

params [
    ["_pos", [0, 0, 0], [[]], 3],
    ["_radius", 80, [0]],
    ["_duration", 30, [0]],
    ["_lethalCore", true, [false]]
];

if (!isServer) exitWith {};
if (!(["cryoblast"] call EFUNC(main,isEffectEnabled))) exitWith {};

_radius = _radius max 10;
_duration = _duration max 5;
_lethalCore = _lethalCore && GVAR(allowDamage);

[QGVAR(cryoBlastLocal), [_pos, _radius, _duration]] call CBA_fnc_globalEvent;

private _caught = (_pos nearEntities [["CAManBase"], _radius]) select {alive _x && {!(_x isKindOf "VirtualMan_F")}};
if (_caught isEqualTo []) exitWith {
    DBG(FORMAT_1("cryo blast fired, radius %1, nobody caught",_radius));
};

[_caught, true] call FUNC(cryoBlastFreeze);

if (_lethalCore) then {
    // Only the core is cold enough to hurt; the rest of the blast just locks
    // people up.
    private _coreRadius = _radius * 0.25;
    {
        private _scaled = linearConversion [0, _coreRadius, _x distance2D _pos, 0.8, 0.2, true];
        [_x, _scaled, "Body", "cold"] call EFUNC(main,doDamage);
    } forEach (_caught select {(_x distance2D _pos) <= _coreRadius});
};

[{
    params ["_caught"];

    // Anyone who died while frozen is dropped from the thaw.
    private _survivors = _caught select {!isNull _x && {alive _x}};
    if (_survivors isEqualTo []) exitWith {};

    [_survivors, false] call FUNC(cryoBlastFreeze);
}, [_caught], _duration] call CBA_fnc_waitAndExecute;

DBG(FORMAT_2("cryo blast fired, radius %1, froze %2 units",_radius,count _caught));
