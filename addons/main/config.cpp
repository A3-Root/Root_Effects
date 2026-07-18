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
    // Themed sub-categories so the many modules group sensibly in the Zeus and
    // 3DEN module menus instead of piling into one long list.
    class ROOT_EFFECTS_BATTLE: NO_CATEGORY {
        displayName = CSTRING(CategoryBattle);
    };
    class ROOT_EFFECTS_STRIKES: NO_CATEGORY {
        displayName = CSTRING(CategoryStrikes);
    };
    class ROOT_EFFECTS_AMBIENT: NO_CATEGORY {
        displayName = CSTRING(CategoryAmbient);
    };
    class ROOT_EFFECTS_WEATHER: NO_CATEGORY {
        displayName = CSTRING(CategoryWeather);
    };
    class ROOT_EFFECTS_TERRAIN: NO_CATEGORY {
        displayName = CSTRING(CategoryTerrain);
    };
    class ROOT_EFFECTS_UFO: NO_CATEGORY {
        displayName = CSTRING(CategoryUfo);
    };
    class ROOT_EFFECTS_PROPS: NO_CATEGORY {
        displayName = CSTRING(CategoryProps);
    };
    class ROOT_EFFECTS_CONTROL: NO_CATEGORY {
        displayName = CSTRING(CategoryControl);
    };
    class ROOT_EFFECTS_UTILITY: NO_CATEGORY {
        displayName = CSTRING(CategoryUtility);
    };
};

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Terminate_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Terminate_ModuleZeus";
        category = "ROOT_EFFECTS_UTILITY";
        function = QFUNC(moduleTerminate);
        displayName = CSTRING(ModuleTerminate);
    };
};
