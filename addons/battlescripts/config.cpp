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
            "ROOT_AAA_ModuleZeus", "ROOT_AAA_Module3DEN",
            "ROOT_Artillery_ModuleZeus", "ROOT_Artillery_Module3DEN",
            "ROOT_Missiles_ModuleZeus", "ROOT_Missiles_Module3DEN",
            "ROOT_Searchlight_ModuleZeus", "ROOT_Searchlight_Module3DEN",
            "ROOT_Tracers_ModuleZeus", "ROOT_Tracers_Module3DEN"
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
        class RootBattleCategory {
            file = QPATHTOF(functions);
            class moduleAntiAirBarrage {};
            class moduleAntiAirBarrage3DEN {};
            class aaaStart {};
            class aaaStartLocal {};
            class aaaBurstLocal {};
            class moduleArtilleryBarrage {};
            class moduleArtilleryBarrage3DEN {};
            class artilleryStart {};
            class artilleryImpactLocal {};
            class moduleMissileLauncher {};
            class moduleMissileLauncher3DEN {};
            class missilesStart {};
            class missileLaunchLocal {};
            class moduleSearchlight {};
            class moduleSearchlight3DEN {};
            class searchlightStart {};
            class searchlightStartLocal {};
            class moduleTracerFire {};
            class moduleTracerFire3DEN {};
            class tracersStart {};
            class tracersStartLocal {};
        };
    };
};

#include "CfgVehicles.hpp"
#include "CfgSounds.hpp"
