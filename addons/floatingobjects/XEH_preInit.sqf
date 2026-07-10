#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make this effect known to the shared registry on every machine.
[
    "floatingobjects",
    LLSTRING(ModuleFloating),
    QGVAR(enabled)
] call EFUNC(main,registerEffect);

ADDON = true;
