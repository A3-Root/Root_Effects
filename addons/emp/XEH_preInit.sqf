#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make this effect known to the shared registry on every machine. The pulse
// is a one-shot event, so it never appears in the termination dialog; the
// registration only feeds the enable setting.
[
    "emp",
    LLSTRING(ModuleEmp),
    QGVAR(enabled)
] call EFUNC(main,registerEffect);

ADDON = true;
