#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["briefingmap", LLSTRING(ModuleMap), QGVAR(enabledMap)] call EFUNC(main,registerEffect);
["briefingtable", LLSTRING(ModuleTable), QGVAR(enabledTable)] call EFUNC(main,registerEffect);

ADDON = true;
