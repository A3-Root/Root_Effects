#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = "Root";
        authors[] = {"Root"};
        url = "https://github.com/A3-Root/Root_Effects";
        addonRootClass = "root_effects_main";
        requiredVersion = REQUIRED_VERSION;
        units[] = {
            "ROOT_LaserStrike_ModuleZeus", "ROOT_LaserStrike_Module3DEN",
            "ROOT_NapalmStrike_ModuleZeus", "ROOT_NapalmStrike_Module3DEN",
            "ROOT_CarpetStrike_ModuleZeus", "ROOT_CarpetStrike_Module3DEN"
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
        class RootStrikesCategory {
            file = QPATHTOF(functions);
            class moduleLaserStrike {};
            class moduleLaserStrike3DEN {};
            class laserStart {};
            class laserLocal {};
            class moduleNapalmStrike {};
            class moduleNapalmStrike3DEN {};
            class napalmStart {};
            class napalmIgnite {};
            class napalmStartLocal {};
            class moduleCarpetStrike {};
            class moduleCarpetStrike3DEN {};
            class carpetStart {};
            class carpetSoundLocal {};
            class moduleSingularity {};
            class moduleSingularity3DEN {};
            class singularityStart {};
            class singularityLocal {};
            class singularityFlingLocal {};
        };
    };
};

#include "CfgVehicles.hpp"
