#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_AMBIENT"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Fireworks_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Fireworks_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleFireworks);
        displayName = CSTRING(ModuleFireworks);
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
    class ROOT_Fireworks_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleFireworks);
        function = QFUNC(moduleFireworks3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_FIREWORKS_DURATION,CSTRING(AttrDuration),CSTRING(AttrDurationTooltip),120);
            ROOT_ATTR_NUMBER(ROOT_FIREWORKS_RATE,CSTRING(AttrRate),CSTRING(AttrRateTooltip),12);
            ROOT_ATTR_NUMBER(ROOT_FIREWORKS_RADIUS,CSTRING(AttrRadius),CSTRING(AttrRadiusTooltip),50);
            ROOT_ATTR_NUMBER(ROOT_FIREWORKS_HEIGHT,CSTRING(AttrHeight),CSTRING(AttrHeightTooltip),150);
            ROOT_ATTR_BOOL(ROOT_FIREWORKS_SOUNDS,CSTRING(AttrSounds),CSTRING(AttrSoundsTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleFireworksDesc);
        };
    };
};
