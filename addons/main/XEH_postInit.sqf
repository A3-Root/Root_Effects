#include "script_component.hpp"

if (isServer) then {
    // Curator asked for the list of running effect instances; answer with a
    // snapshot so their machine can open the termination dialog.
    [QGVAR(requestInstances), {
        params [["_requester", objNull, [objNull]]];
        if (isNull _requester) exitWith {};

        private _data = [];
        {
            private _effectKey = _x;
            private _anchors = (GVAR(instances) getOrDefault [_effectKey, []]) select {!isNull _x};
            GVAR(instances) set [_effectKey, _anchors];

            private _displayName = (GVAR(effectRegistry) getOrDefault [_effectKey, [_effectKey, ""]]) select 0;
            {
                private _elapsed = floor (CBA_missionTime - (_x getVariable [QGVAR(startTime), CBA_missionTime]));
                _data pushBack [_effectKey, _displayName, _x, mapGridPosition _x, _elapsed];
            } forEach _anchors;
        } forEach keys GVAR(instances);

        [QGVAR(showTerminateDialog), [_data], [_requester]] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;

    // Curator confirmed the termination dialog; stop every selected instance.
    [QGVAR(stopRequest), {
        params [["_selections", [], [[]]]];
        {
            _x params ["_mode", ["_effectKey", ""], ["_anchor", objNull]];
            switch (_mode) do {
                case "instance": {
                    [_effectKey, _anchor] call FUNC(stopEffect);
                };
                case "all": {
                    [_effectKey, "ALL"] call FUNC(stopEffect);
                };
                case "everything": {
                    {
                        [_x, "ALL"] call FUNC(stopEffect);
                    } forEach keys GVAR(instances);
                };
            };
        } forEach _selections;
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    // Server answered an instance list request from this machine.
    [QGVAR(showTerminateDialog), {
        params [["_data", [], [[]]]];
        _data call FUNC(terminateDialog);
    }] call CBA_fnc_addEventHandler;
};
