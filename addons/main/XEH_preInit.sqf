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

// Persistent local props (craters, decals and other simple objects) that an
// effect spawns on each machine and leaves in the world, keyed by the netId of
// the instance anchor so they can be cleared when the instance is terminated.
GVAR(localObjects) = createHashMap;

#include "initSettings.inc.sqf"

ADDON = true;
