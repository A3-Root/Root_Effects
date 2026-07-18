#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for modifying a running feed. Asks the server for the
 * current feed list; the reply opens the modify dialog on this machine.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_dronefeed_fnc_moduleModifyFeed
 */

params [["_logic", objNull, [objNull]]];

deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["dronefeed"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

[QGVAR(requestFeedList), ["modify", player]] call CBA_fnc_serverEvent;
