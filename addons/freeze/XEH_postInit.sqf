#include "script_component.hpp"

if (isServer) then {
    [QGVAR(apply), {
        _this call FUNC(freezeApply);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(startCryo), {
        _this call FUNC(cryoBlastStart);
    }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then {
    [QGVAR(cryoBlastLocal), {
        _this call FUNC(cryoBlastLocal);
    }] call CBA_fnc_addEventHandler;
};

// Animation based freezing has to run where the unit is local.
[QGVAR(applyLocal), {
    _this call FUNC(freezeLocal);
}] call CBA_fnc_addEventHandler;
