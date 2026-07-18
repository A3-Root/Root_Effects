#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for creating a feed. Adapts to where the curator
 * dropped the module: on a UAV it asks only for a screen, on a screen object it
 * asks only for a source drone, and on open ground it opens the full setup.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_dronefeed_fnc_moduleCreateFeed
 */

params [["_logic", objNull, [objNull]]];

private _pos = getPosATL _logic;
private _attached = attachedTo _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["dronefeed"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

if (!isNull _attached && {unitIsUAV _attached} && {_attached isKindOf "Air"}) exitWith {
    [_pos, _attached] call FUNC(dialogDroneSource);
};

if (!isNull _attached) exitWith {
    [_pos, _attached] call FUNC(dialogScreenSource);
};

[_pos] call FUNC(dialogCreateFull);
