#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Volcano_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Volcano_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleVolcano);
        displayName = CSTRING(ModuleVolcano);
    };
    class ROOT_Avalanche_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Avalanche_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleAvalanche);
        displayName = CSTRING(ModuleAvalanche);
    };

    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Checkbox;
            class ModuleDescription;
        };
        class ModuleDescription;
    };
    class ROOT_Volcano_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleVolcano);
        function = QFUNC(moduleVolcano3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_VOLCANO_RADIUS,CSTRING(AttrRadius),CSTRING(AttrRadiusTooltip),120);
            ROOT_ATTR_BOOL(ROOT_VOLCANO_ERUPTION,CSTRING(AttrEruption),CSTRING(AttrEruptionTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_VOLCANO_DELAY,CSTRING(AttrDelay),CSTRING(AttrDelayTooltip),300);
            ROOT_ATTR_BOOL(ROOT_VOLCANO_CRATERLAVA,CSTRING(AttrCraterLava),CSTRING(AttrCraterLavaTooltip),false);
            ROOT_ATTR_BOOL(ROOT_VOLCANO_LIGHTNING,CSTRING(AttrLightning),CSTRING(AttrLightningTooltip),false);
            ROOT_ATTR_BOOL(ROOT_VOLCANO_LAVAFLOW,CSTRING(AttrLavaFlow),CSTRING(AttrLavaFlowTooltip),false);
            ROOT_ATTR_BOOL(ROOT_VOLCANO_LETHAL,CSTRING(AttrLethal),CSTRING(AttrLethalTooltip),true);
            ROOT_ATTR_STRING(ROOT_VOLCANO_GEAR,CSTRING(AttrGear),CSTRING(AttrGearTooltip),"''");
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleVolcanoDesc);
        };
    };
    class ROOT_Avalanche_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleAvalanche);
        function = QFUNC(moduleAvalanche3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_BOOL(ROOT_AVALANCHE_DOWNHILL,CSTRING(AttrAvalancheDownhill),CSTRING(AttrAvalancheDownhillTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_AVALANCHE_HEADING,CSTRING(AttrAvalancheHeading),CSTRING(AttrAvalancheHeadingTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_AVALANCHE_LENGTH,CSTRING(AttrAvalancheLength),CSTRING(AttrAvalancheLengthTooltip),200);
            ROOT_ATTR_NUMBER(ROOT_AVALANCHE_DURATION,CSTRING(AttrAvalancheDuration),CSTRING(AttrAvalancheDurationTooltip),25);
            ROOT_ATTR_BOOL(ROOT_AVALANCHE_LETHAL,CSTRING(AttrAvalancheLethal),CSTRING(AttrAvalancheLethalTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleAvalancheDesc);
        };
    };
};
