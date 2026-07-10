#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_EMP_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_EMP_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleEmp);
        displayName = CSTRING(ModuleEmp);
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
    class ROOT_EMP_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleEmp);
        function = QFUNC(moduleEmp3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_EMP_RADIUS,CSTRING(AttrRadius),CSTRING(AttrRadiusTooltip),300);
            ROOT_ATTR_NUMBER(ROOT_EMP_DURATION,CSTRING(AttrDuration),CSTRING(AttrDurationTooltip),20);
            ROOT_ATTR_BOOL(ROOT_EMP_KILLENGINES,CSTRING(AttrKillEngines),CSTRING(AttrKillEnginesTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_EMP_FUELDRAIN,CSTRING(AttrFuelDrain),CSTRING(AttrFuelDrainTooltip),0);
            ROOT_ATTR_BOOL(ROOT_EMP_HUD,CSTRING(AttrHud),CSTRING(AttrHudTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleEmpDesc);
        };
    };
};
