#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = "Root";
        authors[] = {"Root", "Aliascartoons"};
        url = "https://github.com/A3-Root/Root_Effects";
        requiredVersion = REQUIRED_VERSION;
        units[] = {"ROOT_Terminate_ModuleZeus"};
        weapons[] = {};
        requiredAddons[] = {
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
        class RootEffectsFramework {
            file = QPATHTOF(functions);
            class registerEffect {};
            class startEffect {};
            class stopEffect {};
            class doDamage {};
            class doDamageLocal {};
            class doHitPointDamage {};
            class doHitPointDamageLocal {};
            class isEffectEnabled {};
            class log {};
            class moduleTerminate {};
            class terminateDialog {};
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class ROOT_EFFECTS: NO_CATEGORY {
        displayName = CSTRING(CategoryName);
    };
};

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Terminate_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Terminate_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleTerminate);
        displayName = CSTRING(ModuleTerminate);
    };
};
