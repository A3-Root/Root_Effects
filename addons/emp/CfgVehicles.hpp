#include "\z\root_effects\addons\main\module_attributes.hpp"

#define ROOT_MODULE_CATEGORY "ROOT_EFFECTS_STRIKES"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_EMP_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_EMP_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleEmp);
        displayName = CSTRING(ModuleEmp);
    };
    class ROOT_ModifyEmp_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_ModifyEmp_ModuleZeus";
        category = ROOT_MODULE_CATEGORY;
        function = QFUNC(moduleModifyEmp);
        displayName = CSTRING(ModuleModifyEmp);
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
        // Runs when its trigger fires (or at start without one).
        scope = 2;
        category = ROOT_MODULE_CATEGORY;
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 0;
        icon = "\a3\Modules_F_Curator\Data\iconLightning_ca.paa";
        author = "Root";
        displayName = CSTRING(ModuleEmp);
        function = QFUNC(moduleEmp3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_EMP_RADIUS,CSTRING(AttrRadius),CSTRING(AttrRadiusTooltip),300);
            ROOT_ATTR_NUMBER_RAW(ROOT_EMP_ALTITUDE,CSTRING(AttrAltitude),CSTRING(AttrAltitudeTooltip),-1);
            ROOT_ATTR_NUMBER(ROOT_EMP_COUNTDOWN,CSTRING(AttrCountdown),CSTRING(AttrCountdownTooltip),0);
            ROOT_ATTR_NUMBER(ROOT_EMP_DURATION,CSTRING(AttrLinger),CSTRING(AttrLingerTooltip),60);
            ROOT_ATTR_BOOL(ROOT_EMP_PERMANENT,CSTRING(AttrPermanent),CSTRING(AttrPermanentTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_EMP_SHOCKSPEED,CSTRING(AttrShockSpeed),CSTRING(AttrShockSpeedTooltip),150);
            ROOT_ATTR_NUMBER(ROOT_EMP_EFFECTDELAY,CSTRING(AttrEffectDelay),CSTRING(AttrEffectDelayTooltip),1);
            ROOT_ATTR_BOOL(ROOT_EMP_KILLENGINES,CSTRING(AttrKillEngines),CSTRING(AttrKillEnginesTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_EMP_VEHICLES,CSTRING(AttrVehicles),CSTRING(AttrVehiclesTooltip3DEN),1);
            ROOT_ATTR_NUMBER(ROOT_EMP_AIRCRAFT,CSTRING(AttrAircraft),CSTRING(AttrAircraftTooltip3DEN),1);
            ROOT_ATTR_NUMBER(ROOT_EMP_UAVS,CSTRING(AttrUavs),CSTRING(AttrUavsTooltip3DEN),1);
            ROOT_ATTR_BOOL(ROOT_EMP_ELECTRONICS,CSTRING(AttrElectronics),CSTRING(AttrElectronicsTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_EMP_LAMPS,CSTRING(AttrLamps),CSTRING(AttrLampsTooltip3DEN),1);
            ROOT_ATTR_NUMBER(ROOT_EMP_GEAR,CSTRING(AttrGear),CSTRING(AttrGearTooltip3DEN),1);
            ROOT_ATTR_BOOL(ROOT_EMP_AI,CSTRING(AttrAi),CSTRING(AttrAiTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_RADIOS,CSTRING(AttrRadios),CSTRING(AttrRadiosTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_CHANNELS,CSTRING(AttrChannels),CSTRING(AttrChannelsTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_EMP_FUELDRAIN,CSTRING(AttrFuelDrain),CSTRING(AttrFuelDrainTooltip),0);
            ROOT_ATTR_BOOL(ROOT_EMP_RESTORE,CSTRING(AttrRestore),CSTRING(AttrRestoreTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_EMP_GRACE,CSTRING(AttrGrace),CSTRING(AttrGraceTooltip),5);
            ROOT_ATTR_NUMBER(ROOT_EMP_WARNGROUND,CSTRING(AttrWarnGround),CSTRING(AttrWarnTooltip),50);
            ROOT_ATTR_NUMBER(ROOT_EMP_WARNHELI,CSTRING(AttrWarnHeli),CSTRING(AttrWarnTooltip),200);
            ROOT_ATTR_NUMBER(ROOT_EMP_WARNPLANE,CSTRING(AttrWarnPlane),CSTRING(AttrWarnTooltip),500);
            ROOT_ATTR_BOOL(ROOT_EMP_VISUALS,CSTRING(AttrVisuals),CSTRING(AttrVisualsTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_CHARGEGLOW,CSTRING(AttrChargeGlow),CSTRING(AttrChargeGlowTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_SHAKE,CSTRING(AttrShake),CSTRING(AttrShakeTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_HUD,CSTRING(AttrHud),CSTRING(AttrHudTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_DOME,CSTRING(AttrDome),CSTRING(AttrDomeTooltip),true);
            ROOT_ATTR_STRING(ROOT_EMP_DOMECOLOR,CSTRING(AttrDomeColor),CSTRING(AttrDomeColorTooltip3DEN),"'0.5,0.5,0.5'");
            ROOT_ATTR_NUMBER(ROOT_EMP_DOMEALPHA,CSTRING(AttrDomeAlpha),CSTRING(AttrDomeAlphaTooltip),0.03);
            ROOT_ATTR_BOOL(ROOT_EMP_DOMESHIMMER,CSTRING(AttrDomeShimmer),CSTRING(AttrDomeShimmerTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_DOMELIGHTNING,CSTRING(AttrDomeLightning),CSTRING(AttrDomeLightningTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_DOMEMIRAGE,CSTRING(AttrDomeMirage),CSTRING(AttrDomeMirageTooltip),true);
            ROOT_ATTR_NUMBER(ROOT_EMP_DOMEINSIDEALPHA,CSTRING(AttrDomeInsideAlpha),CSTRING(AttrDomeInsideAlphaTooltip3DEN),0);
            ROOT_ATTR_NUMBER(ROOT_EMP_ENDMODE,CSTRING(AttrEndMode),CSTRING(AttrEndModeTooltip3DEN),0);
            ROOT_ATTR_NUMBER(ROOT_EMP_IMPLODEBLAST,CSTRING(AttrImplodeBlast),CSTRING(AttrImplodeBlastTooltip3DEN),0);
            ROOT_ATTR_BOOL(ROOT_EMP_FOG,CSTRING(AttrFog),CSTRING(AttrFogTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_EMP_FOGALPHA,CSTRING(AttrFogAlpha),CSTRING(AttrFogAlphaTooltip3DEN),0.5);
            ROOT_ATTR_BOOL(ROOT_EMP_FLICKERGEAR,CSTRING(AttrFlickerGear),CSTRING(AttrFlickerGearTooltip),false);
            ROOT_ATTR_BOOL(ROOT_EMP_FLICKERVEHICLES,CSTRING(AttrFlickerVehicles),CSTRING(AttrFlickerVehiclesTooltip),false);
            ROOT_ATTR_BOOL(ROOT_EMP_FLICKERLAMPS,CSTRING(AttrFlickerLamps),CSTRING(AttrFlickerLampsTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_EMP_FLICKERONMIN,CSTRING(AttrFlickerOnMin),CSTRING(AttrFlickerOnTooltip),5);
            ROOT_ATTR_NUMBER(ROOT_EMP_FLICKERONMAX,CSTRING(AttrFlickerOnMax),CSTRING(AttrFlickerOnTooltip),20);
            ROOT_ATTR_NUMBER(ROOT_EMP_FLICKEROFFMIN,CSTRING(AttrFlickerOffMin),CSTRING(AttrFlickerOffTooltip),2);
            ROOT_ATTR_NUMBER(ROOT_EMP_FLICKEROFFMAX,CSTRING(AttrFlickerOffMax),CSTRING(AttrFlickerOffTooltip),10);
            ROOT_ATTR_NUMBER(ROOT_EMP_MARKER,CSTRING(AttrMarker),CSTRING(AttrMarkerTooltip3DEN),1);
            ROOT_ATTR_BOOL(ROOT_EMP_MARKERSYNC,CSTRING(AttrMarkerSync),CSTRING(AttrMarkerSyncTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_BEEP,CSTRING(AttrBeep),CSTRING(AttrBeepTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_TIMER3D,CSTRING(AttrTimer3D),CSTRING(AttrTimer3DTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_TIMERHINT,CSTRING(AttrTimerHint),CSTRING(AttrTimerHintTooltip),false);
            ROOT_ATTR_NUMBER(ROOT_EMP_INTERACTION,CSTRING(AttrInteraction),CSTRING(AttrInteractionTooltip3DEN),3);
            ROOT_ATTR_NUMBER(ROOT_EMP_HOLDTIME,CSTRING(AttrHoldTime),CSTRING(AttrHoldTimeTooltip),10);
            ROOT_ATTR_NUMBER(ROOT_EMP_INTERACTDIST,CSTRING(AttrInteractDistance),CSTRING(AttrInteractDistanceTooltip),5);
            ROOT_ATTR_STRING(ROOT_EMP_REQITEM,CSTRING(AttrRequiredItem),CSTRING(AttrRequiredItemTooltip),"''");
            ROOT_ATTR_BOOL(ROOT_EMP_ABORT,CSTRING(AttrAbort),CSTRING(AttrAbortTooltip),true);
            ROOT_ATTR_BOOL(ROOT_EMP_ENDDESTROYED,CSTRING(AttrEndDestroyed),CSTRING(AttrEndDestroyedTooltip),true);
            ROOT_ATTR_STRING(ROOT_EMP_ITEMSEXTRA,CSTRING(AttrItemsExtra),CSTRING(AttrItemsExtraTooltip),"''");
            ROOT_ATTR_STRING(ROOT_EMP_ITEMSIMMUNE,CSTRING(AttrItemsImmune),CSTRING(AttrItemsImmuneTooltip),"''");
            ROOT_ATTR_STRING(ROOT_EMP_VEHIMMUNE,CSTRING(AttrVehiclesImmune),CSTRING(AttrVehiclesImmuneTooltip),"''");
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleEmpDesc);
        };
    };
    class ROOT_ModifyEmp_Module3DEN: Module_F {
        // Runs when its trigger fires (or at start without one), after the field exists.
        scope = 2;
        category = ROOT_MODULE_CATEGORY;
        functionPriority = 5;
        isGlobal = 0;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 0;
        icon = "\a3\Modules_F_Curator\Data\iconLightning_ca.paa";
        author = "Root";
        displayName = CSTRING(ModuleModifyEmp);
        function = QFUNC(moduleModifyEmp3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_NUMBER(ROOT_EMPMOD_RANGE,CSTRING(AttrModRange),CSTRING(AttrModRangeTooltip),3000);
            ROOT_ATTR_BOOL(ROOT_EMPMOD_SHUTDOWN,CSTRING(AttrShutDown),CSTRING(AttrShutDownTooltip),false);
            ROOT_ATTR_NUMBER_RAW(ROOT_EMPMOD_RADIUS,CSTRING(AttrRadius),CSTRING(AttrModRadiusTooltip),-1);
            ROOT_ATTR_NUMBER_RAW(ROOT_EMPMOD_LINGER,CSTRING(AttrLinger),CSTRING(AttrModLingerTooltip),-2);
            ROOT_ATTR_NUMBER_RAW(ROOT_EMPMOD_DOME,CSTRING(AttrDome),CSTRING(AttrModDomeTooltip),-1);
            ROOT_ATTR_STRING(ROOT_EMPMOD_SETTINGS,CSTRING(AttrModSettings),CSTRING(AttrModSettingsTooltip),"''");
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleModifyEmpDesc);
        };
    };
};
