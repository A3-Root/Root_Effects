#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Meteor_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Meteor_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleMeteorsComets);
        displayName = CSTRING(ModuleMeteor);
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
    class ROOT_Meteor_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleMeteor);
        function = QFUNC(moduleMeteorsComets3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_BOOL(ROOT_METEOR_METEORS,CSTRING(AttrMeteors),CSTRING(AttrMeteorsTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_METEOR_METEORFREQ,CSTRING(AttrMeteorFreq),CSTRING(AttrMeteorFreqTooltip),30);
            ROOT_ATTR_BOOL(ROOT_METEOR_COMETS,CSTRING(AttrComets),CSTRING(AttrCometsTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_METEOR_COMETFREQ,CSTRING(AttrCometFreq),CSTRING(AttrCometFreqTooltip),30);
            ROOT_ATTR_BOOL(ROOT_METEOR_LETHAL,CSTRING(AttrLethal),CSTRING(AttrLethalTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleMeteorDesc);
        };
    };
};
