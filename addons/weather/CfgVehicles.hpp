#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_WEATHER"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_LightningStorm_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_LightningStorm_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleLightningStorm);
        displayName = CSTRING(ModuleLightning);
    };
    class ROOT_AcidRain_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_AcidRain_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleAcidRain);
        displayName = CSTRING(ModuleAcidRain);
    };
    class ROOT_HeatMirage_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_HeatMirage_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleHeatMirage);
        displayName = CSTRING(ModuleMirage);
    };
    class ROOT_WaterTint_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_WaterTint_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleWaterTint);
        displayName = CSTRING(ModuleWaterTint);
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
    class ROOT_LightningStorm_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleLightning);
        function = QFUNC(moduleLightningStorm3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_LIGHTNING_RADIUS,CSTRING(AttrLightningRadius),CSTRING(AttrLightningRadiusTooltip),300);
            ROOT_ATTR_NUMBER(ROOT_LIGHTNING_DURATION,CSTRING(AttrLightningDuration),CSTRING(AttrLightningDurationTooltip),300);
            ROOT_ATTR_NUMBER(ROOT_LIGHTNING_MININT,CSTRING(AttrLightningMinInt),CSTRING(AttrLightningMinIntTooltip),5);
            ROOT_ATTR_NUMBER(ROOT_LIGHTNING_MAXINT,CSTRING(AttrLightningMaxInt),CSTRING(AttrLightningMaxIntTooltip),20);
            ROOT_ATTR_BOOL(ROOT_LIGHTNING_DAMAGE,CSTRING(AttrLightningDamage),CSTRING(AttrLightningDamageTooltip),false);
            ROOT_ATTR_BOOL(ROOT_LIGHTNING_AMBIENCE,CSTRING(AttrLightningAmbience),CSTRING(AttrLightningAmbienceTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleLightningDesc);
        };
    };
    class ROOT_AcidRain_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleAcidRain);
        function = QFUNC(moduleAcidRain3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_ACIDRAIN_RADIUS,CSTRING(AttrAcidRadius),CSTRING(AttrAcidRadiusTooltip),500);
            ROOT_ATTR_NUMBER(ROOT_ACIDRAIN_TINT,CSTRING(AttrAcidTint),CSTRING(AttrAcidTintTooltip),0.5);
            ROOT_ATTR_BOOL(ROOT_ACIDRAIN_DAMAGE,CSTRING(AttrAcidDamage),CSTRING(AttrAcidDamageTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_ACIDRAIN_DPS,CSTRING(AttrAcidDps),CSTRING(AttrAcidDpsTooltip),0.05);
            ROOT_ATTR_NUMBER(ROOT_ACIDRAIN_TICK,CSTRING(AttrAcidTick),CSTRING(AttrAcidTickTooltip),5);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleAcidRainDesc);
        };
    };
    class ROOT_HeatMirage_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleMirage);
        function = QFUNC(moduleHeatMirage3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_MIRAGE_RADIUS,CSTRING(AttrMirageRadius),CSTRING(AttrMirageRadiusTooltip),200);
            ROOT_ATTR_NUMBER(ROOT_MIRAGE_INTENSITY,CSTRING(AttrMirageIntensity),CSTRING(AttrMirageIntensityTooltip),0.5);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleMirageDesc);
        };
    };
    class ROOT_WaterTint_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleWaterTint);
        function = QFUNC(moduleWaterTint3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_WATERTINT_RADIUS,CSTRING(AttrTintRadius),CSTRING(AttrTintRadiusTooltip),500);
            ROOT_ATTR_NUMBER(ROOT_WATERTINT_COLOR,CSTRING(AttrTintColor),CSTRING(AttrTintColorTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_WATERTINT_STRENGTH,CSTRING(AttrTintStrength),CSTRING(AttrTintStrengthTooltip),0.6);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleWaterTintDesc);
        };
    };
};
