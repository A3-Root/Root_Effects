#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make this effect known to the shared registry on every machine. Freezing
// toggles unit state rather than running instances, so it never shows up in
// the termination dialog; the registration only feeds the enable setting.
[
    "freeze",
    LLSTRING(ModuleFreeze),
    QGVAR(enabled)
] call EFUNC(main,registerEffect);

// The cryogenic blast is one shot as well, so it stays out of the dialog too.
[
    "cryoblast",
    LLSTRING(ModuleCryo),
    QGVAR(enabledCryo)
] call EFUNC(main,registerEffect);

ADDON = true;
