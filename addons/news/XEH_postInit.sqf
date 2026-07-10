#include "script_component.hpp"

if (hasInterface) then {
    [QGVAR(show), {
        _this call FUNC(showArticleLocal);
    }] call CBA_fnc_addEventHandler;
};
