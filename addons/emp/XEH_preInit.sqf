#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

GVAR(fields) = [];
GVAR(hitList) = [];
GVAR(loopHandle) = -1;
GVAR(suppressHandle) = -1;
GVAR(approachHandle) = -1;
GVAR(flicker) = [];
GVAR(flickerHandle) = -1;

// Make this effect known to the shared registry on every machine.
[
    "emp",
    LLSTRING(ModuleEmp),
    QGVAR(enabled)
] call EFUNC(main,registerEffect);

ADDON = true;
