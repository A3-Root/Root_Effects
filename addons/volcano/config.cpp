#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = "Root";
        authors[] = {"Root", "Aliascartoons"};
        url = "https://github.com/A3-Root/Root_Effects";
        addonRootClass = "root_effects_main";
        requiredVersion = REQUIRED_VERSION;
        units[] = {"ROOT_Volcano_ModuleZeus", "ROOT_Volcano_Module3DEN"};
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
        class RootVolcanoCategory {
            file = QPATHTOF(functions);
            class moduleVolcano {};
            class moduleVolcano3DEN {};
            class volcanoStart {};
            class volcanoStartLocal {};
            class volcanoBurstLocal {};
            class moduleAvalanche {};
            class moduleAvalanche3DEN {};
            class avalancheStart {};
            class avalancheLocal {};
            class volcanoIsProtected {};
        };
    };
};

#include "CfgVehicles.hpp"
#include "CfgSounds.hpp"
