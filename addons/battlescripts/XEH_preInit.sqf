#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["aaa", LLSTRING(ModuleAAA), QGVAR(enabledAAA)] call EFUNC(main,registerEffect);
["artillery", LLSTRING(ModuleArtillery), QGVAR(enabledArtillery)] call EFUNC(main,registerEffect);
["missiles", LLSTRING(ModuleMissiles), QGVAR(enabledMissiles)] call EFUNC(main,registerEffect);
["searchlight", LLSTRING(ModuleSearchlight), QGVAR(enabledSearchlight)] call EFUNC(main,registerEffect);
["tracers", LLSTRING(ModuleTracers), QGVAR(enabledTracers)] call EFUNC(main,registerEffect);

ADDON = true;
