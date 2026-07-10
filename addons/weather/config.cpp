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
            "ROOT_LightningStorm_ModuleZeus", "ROOT_LightningStorm_Module3DEN",
            "ROOT_AcidRain_ModuleZeus", "ROOT_AcidRain_Module3DEN",
            "ROOT_HeatMirage_ModuleZeus", "ROOT_HeatMirage_Module3DEN",
            "ROOT_WaterTint_ModuleZeus", "ROOT_WaterTint_Module3DEN"
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
        class RootWeatherCategory {
            file = QPATHTOF(functions);
            class moduleLightningStorm {};
            class moduleLightningStorm3DEN {};
            class lightningStart {};
            class moduleAcidRain {};
            class moduleAcidRain3DEN {};
            class acidRainStart {};
            class acidRainStartLocal {};
            class moduleHeatMirage {};
            class moduleHeatMirage3DEN {};
            class mirageStart {};
            class mirageStartLocal {};
            class moduleWaterTint {};
            class moduleWaterTint3DEN {};
            class waterTintStart {};
            class waterTintStartLocal {};
        };
    };
};

#include "CfgVehicles.hpp"
