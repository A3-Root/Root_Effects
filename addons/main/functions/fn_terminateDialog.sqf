#include "..\script_component.hpp"

/*
 * Author: Root
 * Opens the effect termination dialog from an instance snapshot supplied by
 * the server. Offers one checkbox per running instance, a stop-all checkbox
 * per effect type with several instances and a global stop checkbox. The
 * confirmed selection is sent back to the server for execution.
 *
 * Arguments:
 * 0: Instance rows [effectKey, displayName, anchor, grid, elapsedSeconds, pausable] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[["volcano", "Volcano Eruption", _anchor, "045012", 60, false]]] call root_effects_main_fnc_terminateDialog
 */

params [["_data", [], [[]]]];

if (!hasInterface) exitWith {};

if (_data isEqualTo []) exitWith {
    [LLSTRING(NoActiveEffects)] call zen_common_fnc_showMessage;
};

private _rows = [];
private _actions = [];

// Number of running instances per effect type, to decide whether a
// stop-all row is worth offering.
private _instanceCounts = createHashMap;
{
    private _countKey = _x select 0;
    _instanceCounts set [_countKey, (_instanceCounts getOrDefault [_countKey, 0]) + 1];
} forEach _data;

// Per instance checkboxes, grouped by effect type in the order received.
private _seenKeys = [];
{
    _x params ["_effectKey", "_displayName", "_anchor", "_grid", "_elapsed", ["_pausable", false]];

    if (!(_effectKey in _seenKeys)) then {
        _seenKeys pushBack _effectKey;

        private _instanceCount = _instanceCounts getOrDefault [_effectKey, 0];
        if (_instanceCount > 1) then {
            _rows pushBack ["TOOLBOX:YESNO", format [LLSTRING(StopAllOfType), _displayName, _instanceCount], false];
            _actions pushBack ["all", _effectKey, objNull];
        };
    };

    private _label = format [LLSTRING(StopInstance), _displayName, _grid, floor (_elapsed / 60), _elapsed mod 60];

    // Pausable effects offer a choice: halt only the ongoing particle spawning,
    // or clear the whole instance gradually. Everything else is a single stop.
    if (_pausable) then {
        _rows pushBack ["TOOLBOX:YESNO", format [LLSTRING(StopParticleCreation), _label], false];
        _actions pushBack ["pause", _effectKey, _anchor];
        _rows pushBack ["TOOLBOX:YESNO", format [LLSTRING(StopFullEffect), _label], false];
        _actions pushBack ["fade", _effectKey, _anchor];
    } else {
        _rows pushBack ["TOOLBOX:YESNO", _label, false];
        _actions pushBack ["instance", _effectKey, _anchor];
    };
} forEach _data;

_rows pushBack ["TOOLBOX:YESNO", LLSTRING(StopEverything), false];
_actions pushBack ["everything", "", objNull];

[LLSTRING(ModuleTerminate), _rows, {
    params ["_results", "_stopActions"];

    private _selections = [];
    {
        if (_x) then {
            _selections pushBack (_stopActions select _forEachIndex);
        };
    } forEach _results;

    if (_selections isEqualTo []) exitWith {};

    [QEGVAR(main,stopRequest), [_selections]] call CBA_fnc_serverEvent;
    [LLSTRING(TerminationSent)] call zen_common_fnc_showMessage;
}, {}, _actions] call zen_dialog_fnc_create;
