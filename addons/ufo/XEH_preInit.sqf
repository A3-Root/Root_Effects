#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["ufoencounter", LLSTRING(ModuleEncounter), QGVAR(enabledEncounter)] call EFUNC(main,registerEffect);
["ufoseeker", LLSTRING(ModuleSeeker), QGVAR(enabledSeeker)] call EFUNC(main,registerEffect);
["cropcircle", LLSTRING(ModuleCropCircle), QGVAR(enabledCropCircle)] call EFUNC(main,registerEffect);

ADDON = true;
