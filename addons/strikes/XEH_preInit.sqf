#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["laserstrike", LLSTRING(ModuleLaser), QGVAR(enabledLaser)] call EFUNC(main,registerEffect);
["napalmstrike", LLSTRING(ModuleNapalm), QGVAR(enabledNapalm)] call EFUNC(main,registerEffect);
["carpetstrike", LLSTRING(ModuleCarpet), QGVAR(enabledCarpet)] call EFUNC(main,registerEffect);

ADDON = true;
