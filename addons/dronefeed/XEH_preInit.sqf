#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the feed effect known to the shared registry so the Terminate Effects
// module can list and stop running feeds too.
["dronefeed", LLSTRING(ModuleCreate), QGVAR(enabled)] call EFUNC(main,registerEffect);

ADDON = true;
