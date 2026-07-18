#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_AMBIENT"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Fireflies_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Fireflies_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleFireflies);
        displayName = CSTRING(ModuleFireflies);
    };
    class ROOT_Aurora_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Aurora_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleAurora);
        displayName = CSTRING(ModuleAurora);
    };
    class ROOT_Rupture_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Rupture_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleRupture);
        displayName = CSTRING(ModuleRupture);
    };
    class ROOT_Sparks_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Sparks_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleSparks);
        displayName = CSTRING(ModuleSparks);
        curatorCanAttach = 1;
    };
    class ROOT_BirdSwarm_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_BirdSwarm_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleBirdSwarm);
        displayName = CSTRING(ModuleBirdSwarm);
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
    class ROOT_Fireflies_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleFireflies);
        function = QFUNC(moduleFireflies3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_FIREFLIES_ALTITUDE,CSTRING(AttrFirefliesAltitude),CSTRING(AttrFirefliesAltitudeTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_FIREFLIES_ACTDIST,CSTRING(AttrFirefliesActDist),CSTRING(AttrFirefliesActDistTooltip),100);
            ROOT_ATTR_BOOL(ROOT_FIREFLIES_FROGS,CSTRING(AttrFirefliesFrogs),CSTRING(AttrFirefliesFrogsTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleFirefliesDesc);
        };
    };
    class ROOT_Aurora_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleAurora);
        function = QFUNC(moduleAurora3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_AURORA_ALTITUDE,CSTRING(AttrAuroraAltitude),CSTRING(AttrAuroraAltitudeTooltip),500);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleAuroraDesc);
        };
    };
    class ROOT_Rupture_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleRupture);
        function = QFUNC(moduleRupture3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_ALTITUDE,CSTRING(AttrRuptureAltitude),CSTRING(AttrRuptureAltitudeTooltip),500);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleRuptureDesc);
        };
    };
    class ROOT_Sparks_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleSparks);
        function = QFUNC(moduleSparks3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_SPARKS_ALTITUDE,CSTRING(AttrSparksAltitude),CSTRING(AttrSparksAltitudeTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_SPARKS_DELAY,CSTRING(AttrSparksDelay),CSTRING(AttrSparksDelayTooltip),10);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleSparksDesc);
        };
    };
    class ROOT_BirdSwarm_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleBirdSwarm);
        function = QFUNC(moduleBirdSwarm3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_BIRDSWARM_COUNT,CSTRING(AttrBirdCount),CSTRING(AttrBirdCountTooltip),15);
            ROOT_ATTR_NUMBER(ROOT_BIRDSWARM_RADIUS,CSTRING(AttrBirdRadius),CSTRING(AttrBirdRadiusTooltip),150);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleBirdSwarmDesc);
        };
    };
};
