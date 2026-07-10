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
            "ROOT_BriefingMap_ModuleZeus", "ROOT_BriefingMap_Module3DEN",
            "ROOT_BriefingTable_ModuleZeus", "ROOT_BriefingTable_Module3DEN"
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
        class RootBriefingCategory {
            file = QPATHTOF(functions);
            class moduleBriefingMap {};
            class moduleBriefingMap3DEN {};
            class briefingMapStart {};
            class briefingMapStartLocal {};
            class moduleBriefingTable {};
            class moduleBriefingTable3DEN {};
            class briefingTableStart {};
            class briefingTableStartLocal {};
        };
    };
};

#include "CfgVehicles.hpp"
