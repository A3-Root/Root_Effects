#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = "Root";
        authors[] = {"Root"};
        url = "https://github.com/A3-Root/Root_Effects";
        addonRootClass = "root_effects_main";
        requiredVersion = REQUIRED_VERSION;
        units[] = {"ROOT_EMP_ModuleZeus", "ROOT_EMP_Module3DEN"};
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
        class RootEmpCategory {
            file = QPATHTOF(functions);
            class moduleEmp {};
            class moduleEmp3DEN {};
            class empStart {};
            class empLocal {};
            class empVehicleLocal {};
            class empLampsLocal {};
            class empUnitLocal {};
        };
    };
};

#include "CfgVehicles.hpp"
