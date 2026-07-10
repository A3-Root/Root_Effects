#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["lightningstorm", LLSTRING(ModuleLightning), QGVAR(enabledLightning)] call EFUNC(main,registerEffect);
["acidrain", LLSTRING(ModuleAcidRain), QGVAR(enabledAcidRain)] call EFUNC(main,registerEffect);
["heatmirage", LLSTRING(ModuleMirage), QGVAR(enabledMirage)] call EFUNC(main,registerEffect);
["watertint", LLSTRING(ModuleWaterTint), QGVAR(enabledWaterTint)] call EFUNC(main,registerEffect);

ADDON = true;
