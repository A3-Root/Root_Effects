#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = "Root";
        authors[] = {"Root", "Aliascartoons"};
        url = "https://github.com/A3-Root/Root_Effects";
        addonRootClass = "root_effects_main";
        requiredVersion = REQUIRED_VERSION;
        units[] = {
            "ROOT_UfoEncounter_ModuleZeus", "ROOT_UfoEncounter_Module3DEN",
            "ROOT_UfoSeeker_ModuleZeus", "ROOT_UfoSeeker_Module3DEN",
            "ROOT_UfoCropCircle_ModuleZeus", "ROOT_UfoCropCircle_Module3DEN"
        };
        weapons[] = {};
        requiredAddons[] = {
            "root_effects_main",
            "A3_Modules_F_Curator",
            "3DEN",
            "cba_main",
            "zen_custom_modules"
        };
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class CfgFunctions {
    class ADDON {
        tag = QUOTE(ADDON);
        class RootUfoCategory {
            file = QPATHTOF(functions);
            class moduleUfoEncounter {};
            class moduleUfoEncounter3DEN {};
            class moduleUfoSeeker {};
            class moduleUfoSeeker3DEN {};
            class moduleUfoCropCircle {};
            class moduleUfoCropCircle3DEN {};
            class encounterStart {};
            class seekerStart {};
            class cropCircleStart {};
            class pickTarget {};
            class crossFlyby {};
            class crossLocal {};
            class jumpLocal {};
            class seekerLocal {};
            class cropCircleLocal {};
        };
    };
};

#include "CfgVehicles.hpp"
#include "CfgSounds.hpp"
