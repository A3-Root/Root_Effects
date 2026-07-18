#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_STRIKES"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_LaserStrike_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_LaserStrike_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleLaserStrike);
        displayName = CSTRING(ModuleLaser);
    };
    class ROOT_NapalmStrike_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_NapalmStrike_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleNapalmStrike);
        displayName = CSTRING(ModuleNapalm);
    };
    class ROOT_CarpetStrike_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_CarpetStrike_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleCarpetStrike);
        displayName = CSTRING(ModuleCarpet);
    };
    class ROOT_Singularity_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Singularity_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleSingularity);
        displayName = CSTRING(ModuleSingularity);
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
    class ROOT_LaserStrike_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleLaser);
        function = QFUNC(moduleLaserStrike3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_LASER_CHARGE,CSTRING(AttrLaserCharge),CSTRING(AttrLaserChargeTooltip),5);
            ROOT_ATTR_NUMBER(ROOT_LASER_BEAM,CSTRING(AttrLaserBeam),CSTRING(AttrLaserBeamTooltip),3);
            ROOT_ATTR_NUMBER(ROOT_LASER_THICKNESS,CSTRING(AttrLaserThickness),CSTRING(AttrLaserThicknessTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_LASER_RED,CSTRING(AttrLaserRed),CSTRING(AttrLaserRedTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_LASER_GREEN,CSTRING(AttrLaserGreen),CSTRING(AttrLaserGreenTooltip),0.2);
            ROOT_ATTR_NUMBER(ROOT_LASER_BLUE,CSTRING(AttrLaserBlue),CSTRING(AttrLaserBlueTooltip),0.2);
            ROOT_ATTR_BOOL(ROOT_LASER_DAMAGE,CSTRING(AttrLaserDamage),CSTRING(AttrLaserDamageTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_LASER_DMGRADIUS,CSTRING(AttrLaserDmgRadius),CSTRING(AttrLaserDmgRadiusTooltip),30);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleLaserDesc);
        };
    };
    class ROOT_NapalmStrike_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleNapalm);
        function = QFUNC(moduleNapalmStrike3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_STRING(ROOT_NAPALM_PLANE,CSTRING(AttrNapalmPlane),CSTRING(AttrNapalmPlaneTooltip),"'B_Plane_CAS_01_dynamicLoadout_F'");
            ROOT_ATTR_NUMBER(ROOT_NAPALM_HEADING,CSTRING(AttrNapalmHeading),CSTRING(AttrNapalmHeadingTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_NAPALM_LENGTH,CSTRING(AttrNapalmLength),CSTRING(AttrNapalmLengthTooltip),150);
            ROOT_ATTR_NUMBER(ROOT_NAPALM_DURATION,CSTRING(AttrNapalmDuration),CSTRING(AttrNapalmDurationTooltip),180);
            ROOT_ATTR_BOOL(ROOT_NAPALM_DAMAGE,CSTRING(AttrNapalmDamage),CSTRING(AttrNapalmDamageTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_NAPALM_DROPDELAY,CSTRING(AttrNapalmDropDelay),CSTRING(AttrNapalmDropDelayTooltip),20);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleNapalmDesc);
        };
    };
    class ROOT_CarpetStrike_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleCarpet);
        function = QFUNC(moduleCarpetStrike3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_STRING(ROOT_CARPET_PLANE,CSTRING(AttrCarpetPlane),CSTRING(AttrCarpetPlaneTooltip),"'B_Plane_CAS_01_dynamicLoadout_F'");
            ROOT_ATTR_NUMBER(ROOT_CARPET_PLANES,CSTRING(AttrCarpetPlanes),CSTRING(AttrCarpetPlanesTooltip),1);
            ROOT_ATTR_STRING(ROOT_CARPET_BOMB,CSTRING(AttrCarpetBomb),CSTRING(AttrCarpetBombTooltip),"'Bo_Mk82'");
            ROOT_ATTR_NUMBER(ROOT_CARPET_HEADING,CSTRING(AttrCarpetHeading),CSTRING(AttrCarpetHeadingTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_CARPET_COUNT,CSTRING(AttrCarpetCount),CSTRING(AttrCarpetCountTooltip),50);
            ROOT_ATTR_NUMBER(ROOT_CARPET_LENGTH,CSTRING(AttrCarpetLength),CSTRING(AttrCarpetLengthTooltip),150);
            ROOT_ATTR_NUMBER(ROOT_CARPET_DELAY,CSTRING(AttrCarpetDelay),CSTRING(AttrCarpetDelayTooltip),35);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleCarpetDesc);
        };
    };
    class ROOT_Singularity_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleSingularity);
        function = QFUNC(moduleSingularity3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_SINGULARITY_RADIUS,CSTRING(AttrSingularityRadius),CSTRING(AttrSingularityRadiusTooltip),120);
            ROOT_ATTR_NUMBER(ROOT_SINGULARITY_CHARGE,CSTRING(AttrSingularityCharge),CSTRING(AttrSingularityChargeTooltip),6);
            ROOT_ATTR_BOOL(ROOT_SINGULARITY_LETHAL,CSTRING(AttrSingularityLethal),CSTRING(AttrSingularityLethalTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleSingularityDesc);
        };
    };
};
