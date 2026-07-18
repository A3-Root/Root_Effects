#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["fireflies", LLSTRING(ModuleFireflies), QGVAR(enabledFireflies)] call EFUNC(main,registerEffect);
["aurora", LLSTRING(ModuleAurora), QGVAR(enabledAurora), true] call EFUNC(main,registerEffect);
["rupture", LLSTRING(ModuleRupture), QGVAR(enabledRupture), true] call EFUNC(main,registerEffect);
["sparks", LLSTRING(ModuleSparks), QGVAR(enabledSparks)] call EFUNC(main,registerEffect);
["birdswarm", LLSTRING(ModuleBirdSwarm), QGVAR(enabledBirdSwarm)] call EFUNC(main,registerEffect);

ADDON = true;
