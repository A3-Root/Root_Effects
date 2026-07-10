#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_UfoEncounter_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_UfoEncounter_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleUfoEncounter);
        displayName = CSTRING(ModuleEncounter);
    };
    class ROOT_UfoSeeker_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_UfoSeeker_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleUfoSeeker);
        displayName = CSTRING(ModuleSeeker);
    };
    class ROOT_UfoCropCircle_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_UfoCropCircle_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleUfoCropCircle);
        displayName = CSTRING(ModuleCropCircle);
    };

    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Combo;
            class ModuleDescription;
        };
        class ModuleDescription;
    };
    class ROOT_UfoEncounter_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleEncounter);
        function = QFUNC(moduleUfoEncounter3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_UFO_ENCOUNTERFREQ,CSTRING(AttrEncounterFreq),CSTRING(AttrEncounterFreqTooltip),30);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleEncounterDesc);
        };
    };
    class ROOT_UfoSeeker_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleSeeker);
        function = QFUNC(moduleUfoSeeker3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_UFO_SEEKERFREQ,CSTRING(AttrSeekerFreq),CSTRING(AttrSeekerFreqTooltip),30);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleSeekerDesc);
        };
    };
    class ROOT_UfoCropCircle_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleCropCircle);
        function = QFUNC(moduleUfoCropCircle3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_UFO_CROPRADIUS,CSTRING(AttrCropRadius),CSTRING(AttrCropRadiusTooltip),50);
            class ROOT_UFO_CROPTYPE: Combo {
                property = "ROOT_UFO_CROPTYPE";
                displayName = CSTRING(AttrCropType);
                tooltip = CSTRING(AttrCropTypeTooltip);
                typeName = "STRING";
                defaultValue = "'circle'";
                class Values {
                    class circle {
                        name = CSTRING(CropTypeCircle);
                        value = "circle";
                    };
                    class spiral {
                        name = CSTRING(CropTypeSpiral);
                        value = "spiral";
                    };
                    class flower {
                        name = CSTRING(CropTypeFlower);
                        value = "flower";
                    };
                };
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleCropCircleDesc);
        };
    };
};
