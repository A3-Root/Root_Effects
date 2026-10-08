#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_AMBIENT"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_Fireflies_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Fireflies_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleFireflies);
        displayName = CSTRING(ModuleFireflies);
    };
    class ROOT_Aurora_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Aurora_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleAurora);
        displayName = CSTRING(ModuleAurora);
    };
    class ROOT_Rupture_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Rupture_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleRupture);
        displayName = CSTRING(ModuleRupture);
    };
    class ROOT_Sparks_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_Sparks_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleSparks);
        displayName = CSTRING(ModuleSparks);
        curatorCanAttach = 1;
    };
    class ROOT_ModifySky_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_ModifySky_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleModifySky);
        displayName = CSTRING(ModuleModifySky);
    };
    class ROOT_BirdSwarm_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_BirdSwarm_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleBirdSwarm);
        displayName = CSTRING(ModuleBirdSwarm);
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
    class ROOT_Fireflies_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleFireflies);
        function = QFUNC(moduleFireflies3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_FIREFLIES_ALTITUDE,CSTRING(AttrFirefliesAltitude),CSTRING(AttrFirefliesAltitudeTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_FIREFLIES_ACTDIST,CSTRING(AttrFirefliesActDist),CSTRING(AttrFirefliesActDistTooltip),100);
            ROOT_ATTR_BOOL(ROOT_FIREFLIES_FROGS,CSTRING(AttrFirefliesFrogs),CSTRING(AttrFirefliesFrogsTooltip),true);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleFirefliesDesc);
        };
    };
    class ROOT_Aurora_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleAurora);
        function = QFUNC(moduleAurora3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_AURORA_ALTITUDE,CSTRING(AttrAuroraAltitude),CSTRING(AttrAuroraAltitudeTooltip),500);
            ROOT_ATTR_NUMBER(ROOT_AURORA_SHAPE,CSTRING(AttrSkyShape),CSTRING(AttrSkyShapeTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_AURORA_FADEIN,CSTRING(AttrSkyFadeIn),CSTRING(AttrSkyFadeInTooltip),20);
            ROOT_ATTR_NUMBER(ROOT_AURORA_FADEOUT,CSTRING(AttrSkyFadeOut),CSTRING(AttrSkyFadeOutTooltip),20);
            ROOT_ATTR_NUMBER(ROOT_AURORA_LIFETIME,CSTRING(AttrSkyLifetime),CSTRING(AttrSkyLifetimeTooltip),180);
            ROOT_ATTR_NUMBER(ROOT_AURORA_DENSITY,CSTRING(AttrSkyDensity),CSTRING(AttrSkyDensityTooltip),0.5);
            ROOT_ATTR_BOOL(ROOT_AURORA_FIXED,CSTRING(AttrSkyFixed),CSTRING(AttrSkyFixedTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_AURORA_SIZE,CSTRING(AttrSkySize),CSTRING(AttrSkySizeTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_AURORA_LENGTH,CSTRING(AttrSkyLength),CSTRING(AttrSkyLengthTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_AURORA_SWITCH,CSTRING(AttrSkySwitch),CSTRING(AttrSkySwitchTooltip),0);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleAuroraDesc);
        };
    };
    class ROOT_Rupture_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleRupture);
        function = QFUNC(moduleRupture3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_ALTITUDE,CSTRING(AttrRuptureAltitude),CSTRING(AttrRuptureAltitudeTooltip),500);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_SHAPE,CSTRING(AttrSkyShape),CSTRING(AttrSkyShapeTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_FADEIN,CSTRING(AttrSkyFadeIn),CSTRING(AttrSkyFadeInTooltip),20);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_FADEOUT,CSTRING(AttrSkyFadeOut),CSTRING(AttrSkyFadeOutTooltip),20);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_LIFETIME,CSTRING(AttrSkyLifetime),CSTRING(AttrSkyLifetimeTooltip),180);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_DENSITY,CSTRING(AttrSkyDensity),CSTRING(AttrSkyDensityTooltip),0.5);
            ROOT_ATTR_BOOL(ROOT_RUPTURE_FIXED,CSTRING(AttrSkyFixed),CSTRING(AttrSkyFixedTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_SIZE,CSTRING(AttrSkySize),CSTRING(AttrSkySizeTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_LENGTH,CSTRING(AttrSkyLength),CSTRING(AttrSkyLengthTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_SWITCH,CSTRING(AttrSkySwitch),CSTRING(AttrSkySwitchTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_MOVESPEED,CSTRING(AttrSkyMoveSpeed),CSTRING(AttrSkyMoveSpeedTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_RUPTURE_MOVEMODE,CSTRING(AttrSkyMoveMode),CSTRING(AttrSkyMoveModeTooltip3DEN),0);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleRuptureDesc);
        };
    };
    class ROOT_ModifySky_Module3DEN: Module_F {
        // Runs when its trigger fires (or at start without one), after the sky effects exist.
        scope = 2;
        category = ROOT_MODULE_CATEGORY;
        functionPriority = 5;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 0;
        icon = "\a3\Modules_F_Curator\Data\iconLightning_ca.paa";
        author = "Root";
        displayName = CSTRING(ModuleModifySky);
        function = QFUNC(moduleModifySky3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_RANGE,CSTRING(AttrSkyModRange),CSTRING(AttrSkyModRangeTooltip),3000);
            ROOT_ATTR_BOOL(ROOT_SKYMOD_FREEZE,CSTRING(AttrSkyModFreeze),CSTRING(AttrSkyModFreezeTooltip),false);
            ROOT_ATTR_BOOL(ROOT_SKYMOD_SPAWN,CSTRING(AttrSkyModSpawn),CSTRING(AttrSkyModSpawnTooltip),true);
            ROOT_ATTR_BOOL(ROOT_SKYMOD_DESPAWN,CSTRING(AttrSkyModDespawn),CSTRING(AttrSkyModDespawnTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_SIZE,CSTRING(AttrSkySize),CSTRING(AttrSkySizeTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_LENGTH,CSTRING(AttrSkyLength),CSTRING(AttrSkyLengthTooltip),1);
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_SHAPE,CSTRING(AttrSkyModShape),CSTRING(AttrSkyModShapeTooltip),6);
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_SWITCH,CSTRING(AttrSkySwitch),CSTRING(AttrSkySwitchTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_MOVESPEED,CSTRING(AttrSkyMoveSpeed),CSTRING(AttrSkyMoveSpeedTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_SKYMOD_MOVEMODE,CSTRING(AttrSkyMoveMode),CSTRING(AttrSkyMoveModeTooltip3DEN),0);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleModifySkyDesc);
        };
    };
    class ROOT_Sparks_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleSparks);
        function = QFUNC(moduleSparks3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_SPARKS_ALTITUDE,CSTRING(AttrSparksAltitude),CSTRING(AttrSparksAltitudeTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_SPARKS_DELAY,CSTRING(AttrSparksDelay),CSTRING(AttrSparksDelayTooltip),10);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleSparksDesc);
        };
    };
    class ROOT_BirdSwarm_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleBirdSwarm);
        function = QFUNC(moduleBirdSwarm3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_BIRDSWARM_COUNT,CSTRING(AttrBirdCount),CSTRING(AttrBirdCountTooltip),15);
            ROOT_ATTR_NUMBER(ROOT_BIRDSWARM_RADIUS,CSTRING(AttrBirdRadius),CSTRING(AttrBirdRadiusTooltip),150);
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleBirdSwarmDesc);
        };
    };
};
