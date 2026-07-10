#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_BriefingMap_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_BriefingMap_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleBriefingMap);
        displayName = CSTRING(ModuleMap);
    };
    class ROOT_BriefingTable_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_BriefingTable_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleBriefingTable);
        displayName = CSTRING(ModuleTable);
        curatorCanAttach = 1;
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
    class ROOT_BriefingMap_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleMap);
        function = QFUNC(moduleBriefingMap3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_BMAP_ZOOM,CSTRING(AttrMapZoom),CSTRING(AttrMapZoomTooltip),0.1);
            ROOT_ATTR_NUMBER(ROOT_BMAP_ACTDIST,CSTRING(AttrMapActDist),CSTRING(AttrMapActDistTooltip),50);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleMapDesc);
        };
    };
    class ROOT_BriefingTable_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleTable);
        function = QFUNC(moduleBriefingTable3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_STRING(ROOT_BTABLE_MARKER,CSTRING(AttrTableMarker),CSTRING(AttrTableMarkerTooltip),"''");
            ROOT_ATTR_NUMBER(ROOT_BTABLE_RESOLUTION,CSTRING(AttrTableResolution),CSTRING(AttrTableResolutionTooltip),20);
            ROOT_ATTR_NUMBER(ROOT_BTABLE_SCALE,CSTRING(AttrTableScale),CSTRING(AttrTableScaleTooltip),1);
            ROOT_ATTR_BOOL(ROOT_BTABLE_TERRAIN,CSTRING(AttrTableTerrain),CSTRING(AttrTableTerrainTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleTableDesc);
        };
    };
};
