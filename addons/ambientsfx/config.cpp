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
            "ROOT_Fireflies_ModuleZeus", "ROOT_Fireflies_Module3DEN",
            "ROOT_Aurora_ModuleZeus", "ROOT_Aurora_Module3DEN",
            "ROOT_Rupture_ModuleZeus", "ROOT_Rupture_Module3DEN",
            "ROOT_ModifySky_ModuleZeus", "ROOT_ModifySky_Module3DEN",
            "ROOT_Sparks_ModuleZeus", "ROOT_Sparks_Module3DEN",
            "ROOT_BirdSwarm_ModuleZeus", "ROOT_BirdSwarm_Module3DEN"
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

#include "CfgVehicles.hpp"
#include "CfgSounds.hpp"
