#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Make the effects of this component known to the shared registry.
["meteors", LLSTRING(EffectMeteors), QGVAR(enabled)] call EFUNC(main,registerEffect);
["comets", LLSTRING(EffectComets), QGVAR(enabled)] call EFUNC(main,registerEffect);

ADDON = true;
