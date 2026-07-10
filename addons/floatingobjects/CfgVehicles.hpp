#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_FloatingObjects_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_FloatingObjects_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleFloatingObjects);
        displayName = CSTRING(ModuleFloating);
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
    class ROOT_FloatingObjects_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleFloating);
        function = QFUNC(moduleFloatingObjects3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_FLOAT_ELEVATION,CSTRING(AttrElevation),CSTRING(AttrElevationTooltip),5);
            ROOT_ATTR_BOOL(ROOT_FLOAT_DAMAGE,CSTRING(AttrDamage),CSTRING(AttrDamageTooltip),true);
            ROOT_ATTR_BOOL(ROOT_FLOAT_SIMULATION,CSTRING(AttrSimulation),CSTRING(AttrSimulationTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_SLIDEVEL,CSTRING(AttrSlideVel),CSTRING(AttrSlideVelTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_SLIDEDIST,CSTRING(AttrSlideDist),CSTRING(AttrSlideDistTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_BOUNCESPEED,CSTRING(AttrBounceSpeed),CSTRING(AttrBounceSpeedTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_BOUNCEALT,CSTRING(AttrBounceAlt),CSTRING(AttrBounceAltTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_ROTVEL,CSTRING(AttrRotVel),CSTRING(AttrRotVelTooltip),1);
            ROOT_ATTR_BOOL(ROOT_FLOAT_ROTCW,CSTRING(AttrRotCw),CSTRING(AttrRotCwTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_ROLLVEL,CSTRING(AttrRollVel),CSTRING(AttrRollVelTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_ORBITRADIUS,CSTRING(AttrOrbitRadius),CSTRING(AttrOrbitRadiusTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_ORBITSPEED,CSTRING(AttrOrbitSpeed),CSTRING(AttrOrbitSpeedTooltip),0.1);
            ROOT_ATTR_BOOL(ROOT_FLOAT_ORBITCW,CSTRING(AttrOrbitCw),CSTRING(AttrOrbitCwTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_FLOAT_ACTDIST,CSTRING(AttrActDist),CSTRING(AttrActDistTooltip),9999);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleFloatingDesc);
        };
    };
};
