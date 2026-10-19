#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module entry point for the EMP field. Placed on an object, the field sits
 * on it; placed on the ground, at that spot. Opens the dialog on the curator's
 * machine and asks the server to create the field once confirmed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_emp_fnc_moduleEmp
 */

params [["_logic", objNull, [objNull]]];

DBG(FORMAT_3("moduleEmp called with %1 by %2 at %3",_this,profileName,mapGridPosition (positionCameraToWorld [ARR_3(0,0,0)])));

private _object = attachedTo _logic;
private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

if (!(["emp"] call EFUNC(main,isEffectEnabled))) exitWith {
    [localize ELSTRING(main,EffectDisabled)] call zen_common_fnc_showMessage;
};

([call FUNC(empDefaults), _pos, true] call FUNC(empDialogRows)) params ["_rows", "_keys"];

[LLSTRING(ModuleEmp), _rows, {
    params ["_results", "_args"];
    _args params ["_object", "_pos", "_keys"];

    private _settings = [];
    {
        _settings pushBack [_x, _results select _forEachIndex];
    } forEach _keys;

    private _target = [_pos, _object] select (!isNull _object);
    [QGVAR(create), [_target, _settings]] call EFUNC(main,serverEventLogged);
    DBG(FORMAT_3("EMP field requested by %1 at %2 on %3",profileName,mapGridPosition _pos,typeOf _object));
    [LLSTRING(Started)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_object, _pos, _keys], QGVAR(dialog)] call zen_dialog_fnc_create;
