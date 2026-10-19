#include "..\script_component.hpp"

/*
 * Author: Root
 * Zeus module: changes or shuts down a running EMP field live. Placed on the
 * field's object it picks that field, otherwise the closest one. The dialog
 * starts from the field's current settings.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call root_effects_emp_fnc_moduleModifyEmp
 */

params [["_logic", objNull, [objNull]]];

DBG(FORMAT_3("moduleModifyEmp called with %1 by %2 at %3",_this,profileName,mapGridPosition (positionCameraToWorld [ARR_3(0,0,0)])));

private _object = attachedTo _logic;
private _pos = getPosATL _logic;
deleteVehicle _logic;

if (!hasInterface) exitWith {};

private _anchor = _object getVariable [QGVAR(anchor), objNull];
if (isNull _anchor) then {
    private _anchors = (nearestObjects [[_pos select 0, _pos select 1, 0], [ANCHOR_CLASS], 8000]) select {
        (_x getVariable [QEGVAR(main,effectKey), ""]) isEqualTo "emp" && {!(_x getVariable [QGVAR(ending), false])}
    };
    _anchor = _anchors param [0, objNull];
};
if (isNull _anchor) exitWith {
    [LLSTRING(NoField)] call zen_common_fnc_showMessage;
};

private _cfg = createHashMapFromArray (_anchor getVariable [QGVAR(cfg), []]);
private _defaults = call FUNC(empDefaults);
_defaults merge [_cfg, true];
([_defaults, getPosATL _anchor, false] call FUNC(empDialogRows)) params ["_rows", "_keys"];
_rows insert [0, [["TOOLBOX:YESNO", [LLSTRING(AttrShutDown), LLSTRING(AttrShutDownTooltip)], false]]];

[format [LLSTRING(ModuleModifyEmpTitle), mapGridPosition _anchor], _rows, {
    params ["_results", "_args"];
    _args params ["_anchor", "_keys"];
    if (isNull _anchor) exitWith {
        [LLSTRING(NoField)] call zen_common_fnc_showMessage;
    };
    if (_results select 0) exitWith {
        [QGVAR(disable), [_anchor]] call EFUNC(main,serverEventLogged);
        [LLSTRING(FieldShutDown)] call zen_common_fnc_showMessage;
    };

    private _settings = [];
    {
        _settings pushBack [_x, _results select (_forEachIndex + 1)];
    } forEach _keys;
    [QGVAR(modify), [_anchor, _settings]] call EFUNC(main,serverEventLogged);
    DBG(FORMAT_2("EMP modify requested by %1 for %2",profileName,mapGridPosition _anchor));
    [LLSTRING(FieldModified)] call zen_common_fnc_showMessage;
}, {
    [localize ELSTRING(main,Aborted)] call zen_common_fnc_showMessage;
}, [_anchor, _keys], QGVAR(modifyDialog)] call zen_dialog_fnc_create;
