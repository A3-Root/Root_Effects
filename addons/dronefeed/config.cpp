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
            "ROOT_DroneFeed_Create_ModuleZeus",
            "ROOT_DroneFeed_Modify_ModuleZeus",
            "ROOT_DroneFeed_Delete_ModuleZeus",
            "ROOT_DroneFeed_KillAll_ModuleZeus",
            "ROOT_DroneFeed_Module3DEN"
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
        class RootDroneFeedCategory {
            file = QPATHTOF(functions);
            class moduleCreateFeed {};
            class moduleCreateFeed3DEN {};
            class moduleModifyFeed {};
            class moduleDeleteFeed {};
            class moduleKillAll {};
            class dialogCreateFull {};
            class dialogDroneSource {};
            class dialogScreenSource {};
            class dialogModify {};
            class dialogDelete {};
            class serverCreateFeed {};
            class serverDeleteFeed {};
            class serverModifyFeed {};
            class serverKillAll {};
            class serverMonitor {};
            class spawnDrone {};
            class setupFeedLocal {};
            class activateFeed {};
            class deactivateFeed {};
            class teardownFeedLocal {};
            class getTurretAim {};
            class addActions {};
            class removeActions {};
            class getDroneList {};
            class getScreenList {};
        };
    };
};

#include "CfgVehicles.hpp"
