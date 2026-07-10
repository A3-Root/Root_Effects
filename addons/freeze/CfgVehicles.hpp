#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Freeze_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Freeze_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleFreezePlayers);
        displayName = CSTRING(ModuleFreeze);
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
    class ROOT_Freeze_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleFreeze);
        function = QFUNC(moduleFreezePlayers3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_BOOL(ROOT_FREEZE_FREEZE,CSTRING(AttrFreeze),CSTRING(AttrFreezeTooltip),true);
            ROOT_ATTR_BOOL(ROOT_FREEZE_USEANIM,CSTRING(AttrUseAnim),CSTRING(AttrUseAnimTooltip),false);
            ROOT_ATTR_STRING(ROOT_FREEZE_ANIM,CSTRING(AttrAnim),CSTRING(AttrAnimTooltip),"'HubSpectator_stand'");
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleFreezeDesc);
        };
    };
};
