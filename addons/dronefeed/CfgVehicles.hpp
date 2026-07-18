#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_PROPS"

class CfgVehicles {
    class zen_modules_moduleBase;

    class ROOT_DroneFeed_Create_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_DroneFeed_Create_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleCreateFeed);
        displayName = CSTRING(ModuleCreate);
        description = CSTRING(ModuleCreateDesc);
        curatorCanAttach = 1;
    };

    class ROOT_DroneFeed_Modify_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_DroneFeed_Modify_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleModifyFeed);
        displayName = CSTRING(ModuleModify);
        description = CSTRING(ModuleModifyDesc);
    };

    class ROOT_DroneFeed_Delete_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_DroneFeed_Delete_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleDeleteFeed);
        displayName = CSTRING(ModuleDelete);
        description = CSTRING(ModuleDeleteDesc);
    };

    class ROOT_DroneFeed_KillAll_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_DroneFeed_KillAll_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleKillAll);
        displayName = CSTRING(ModuleKillAll);
        description = CSTRING(ModuleKillAllDesc);
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
    class ROOT_DroneFeed_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleCreate);
        function = QFUNC(moduleCreateFeed3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_STRING(ROOT_DRONEFEED_DRONECLASS,CSTRING(AttrDroneClass),CSTRING(AttrDroneClassTooltip),"'B_UAV_02_dynamicLoadout_F'");
            ROOT_ATTR_NUMBER(ROOT_DRONEFEED_DRONEALT,CSTRING(AttrDroneAlt),CSTRING(AttrDroneAltTooltip),500);
            ROOT_ATTR_STRING(ROOT_DRONEFEED_SCREENCLASS,CSTRING(AttrScreenClass),CSTRING(AttrScreenClassTooltip),"'Land_TripodScreen_01_large_F'");
            ROOT_ATTR_NUMBER(ROOT_DRONEFEED_TEXID,CSTRING(AttrTextureId),CSTRING(AttrTextureIdTooltip),0);
            ROOT_ATTR_BOOL(ROOT_DRONEFEED_SATELLITE,CSTRING(AttrSatellite),CSTRING(AttrSatelliteTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_DRONEFEED_SATALT,CSTRING(AttrSatAlt),CSTRING(AttrSatAltTooltip),1000);
            ROOT_ATTR_NUMBER(ROOT_DRONEFEED_RADIUS,CSTRING(AttrRadius),CSTRING(AttrRadiusTooltip),100);
            ROOT_ATTR_STRING(ROOT_DRONEFEED_VIEW,CSTRING(AttrView),CSTRING(AttrViewTooltip),"'GUNNER'");
            ROOT_ATTR_BOOL(ROOT_DRONEFEED_PROXY,CSTRING(AttrProxy),CSTRING(AttrProxyTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_DRONEFEED_PROXYALT,CSTRING(AttrProxyAlt),CSTRING(AttrProxyAltTooltip),1200);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleCreateDesc);
        };
    };
};
