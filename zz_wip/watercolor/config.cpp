#include "script_component.hpp"
#include "WaterColorParams.hpp"

// Optional standalone addon: recolors the engine water of the vanilla
// terrains to blood red. Purely a config override, applied for the whole
// session while this PBO is loaded; delete the PBO to restore normal water.
// Based on the Red Water Mod approach by ANZACSAS Steve.

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = "Root";
        authors[] = {"Root", "ANZACSAS Steve"};
        url = "https://github.com/A3-Root/Root_Effects";
        addonRootClass = "root_effects_main";
        requiredVersion = REQUIRED_VERSION;
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {
            "root_effects_main",
            "A3_Map_Data",
            "A3_Map_Stratis",
            "A3_Map_Altis",
            "A3_Map_Malden",
            "A3_Map_Tanoabuka",
            "A3_Map_Enoch"
        };
    };
};

class CfgWorlds {
    class WaterExPars;
    class DefaultWorld;
    class CAWorld: DefaultWorld {
        ROOT_WATERCOLOR_SEA;
    };
    class Stratis: CAWorld {
        ROOT_WATERCOLOR_SEA;
    };
    class Altis: CAWorld {
        ROOT_WATERCOLOR_SEA;
    };
    class Malden: CAWorld {
        ROOT_WATERCOLOR_SEA;
    };
    class Tanoa: CAWorld {
        ROOT_WATERCOLOR_SEA;
    };
    class Enoch: CAWorld {
        ROOT_WATERCOLOR_SEA;
    };
};
