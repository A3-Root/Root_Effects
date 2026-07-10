#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// Registry of effect modules provided by loaded effect addons, filled by
// FUNC(registerEffect) during each addon's preInit. Exists on every machine.
GVAR(effectRegistry) = createHashMap;

// Running effect instances per effect key, tracked on the server only.
if (isServer) then {
    GVAR(instances) = createHashMap;
};

// Cached ACE medical presence so damage helpers pick the right code path.
GVAR(aceMedicalLoaded) = isClass (configFile >> "CfgPatches" >> "ace_medical");

#include "initSettings.inc.sqf"

ADDON = true;
