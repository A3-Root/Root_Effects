#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_AAA_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_AAA_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleAntiAirBarrage);
        displayName = CSTRING(ModuleAAA);
    };
    class ROOT_Artillery_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Artillery_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleArtilleryBarrage);
        displayName = CSTRING(ModuleArtillery);
    };
    class ROOT_Missiles_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Missiles_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleMissileLauncher);
        displayName = CSTRING(ModuleMissiles);
    };
    class ROOT_Searchlight_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Searchlight_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleSearchlight);
        displayName = CSTRING(ModuleSearchlight);
    };
    class ROOT_Tracers_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Tracers_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleTracerFire);
        displayName = CSTRING(ModuleTracers);
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
    class ROOT_AAA_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleAAA);
        function = QFUNC(moduleAntiAirBarrage3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_AAA_RADIUS,CSTRING(AttrAaaRadius),CSTRING(AttrAaaRadiusTooltip),500);
            ROOT_ATTR_NUMBER(ROOT_AAA_ALTITUDE,CSTRING(AttrAaaAltitude),CSTRING(AttrAaaAltitudeTooltip),150);
            ROOT_ATTR_BOOL(ROOT_AAA_LETHAL,CSTRING(AttrAaaLethal),CSTRING(AttrAaaLethalTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_AAA_DMGAIR,CSTRING(AttrAaaDmgAir),CSTRING(AttrAaaDmgAirTooltip),0.05);
            ROOT_ATTR_NUMBER(ROOT_AAA_DMGINF,CSTRING(AttrAaaDmgInf),CSTRING(AttrAaaDmgInfTooltip),0.2);
            ROOT_ATTR_NUMBER(ROOT_AAA_DELAY,CSTRING(AttrAaaDelay),CSTRING(AttrAaaDelayTooltip),1);
            ROOT_ATTR_BOOL(ROOT_AAA_SMOKEONLY,CSTRING(AttrAaaSmokeOnly),CSTRING(AttrAaaSmokeOnlyTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_AAA_SPREAD,CSTRING(AttrAaaSpread),CSTRING(AttrAaaSpreadTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_AAA_FIRERATE,CSTRING(AttrAaaFireRate),CSTRING(AttrAaaFireRateTooltip),1);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleAAADesc);
        };
    };
    class ROOT_Artillery_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleArtillery);
        function = QFUNC(moduleArtilleryBarrage3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_ARTY_RADIUS,CSTRING(AttrArtyRadius),CSTRING(AttrArtyRadiusTooltip),500);
            ROOT_ATTR_NUMBER(ROOT_ARTY_MODE,CSTRING(AttrArtyMode),CSTRING(AttrArtyModeTooltip),0);
            ROOT_ATTR_STRING(ROOT_ARTY_SHELL,CSTRING(AttrArtyShell),CSTRING(AttrArtyShellTooltip),"'Sh_155mm_AMOS'");
            ROOT_ATTR_NUMBER(ROOT_ARTY_DELAY,CSTRING(AttrArtyDelay),CSTRING(AttrArtyDelayTooltip),3);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleArtilleryDesc);
        };
    };
    class ROOT_Missiles_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleMissiles);
        function = QFUNC(moduleMissileLauncher3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_MISSILES_SAFEDIST,CSTRING(AttrMissilesSafeDist),CSTRING(AttrMissilesSafeDistTooltip),25);
            ROOT_ATTR_NUMBER(ROOT_MISSILES_DELAY,CSTRING(AttrMissilesDelay),CSTRING(AttrMissilesDelayTooltip),10);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleMissilesDesc);
        };
    };
    class ROOT_Searchlight_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleSearchlight);
        function = QFUNC(moduleSearchlight3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_BOOL(ROOT_SEARCHLIGHT_ALARM,CSTRING(AttrSearchlightAlarm),CSTRING(AttrSearchlightAlarmTooltip),false);
            ROOT_ATTR_BOOL(ROOT_SEARCHLIGHT_ATTACH,CSTRING(AttrSearchlightAttach),CSTRING(AttrSearchlightAttachTooltip),false);
            ROOT_ATTR_BOOL(ROOT_SEARCHLIGHT_AISEARCH,CSTRING(AttrSearchlightAiSearch),CSTRING(AttrSearchlightAiSearchTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleSearchlightDesc);
        };
    };
    class ROOT_Tracers_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleTracers);
        function = QFUNC(moduleTracerFire3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_TRACERS_ACTDIST,CSTRING(AttrTracersActDist),CSTRING(AttrTracersActDistTooltip),150);
            ROOT_ATTR_NUMBER(ROOT_TRACERS_RED,CSTRING(AttrTracersRed),CSTRING(AttrTracersRedTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_TRACERS_GREEN,CSTRING(AttrTracersGreen),CSTRING(AttrTracersGreenTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_TRACERS_BLUE,CSTRING(AttrTracersBlue),CSTRING(AttrTracersBlueTooltip),1);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleTracersDesc);
        };
    };
};
