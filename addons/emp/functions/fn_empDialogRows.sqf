#include "..\script_component.hpp"

/*
 * Author: Root
 * ZEN dialog rows for the EMP field settings, filled from the given settings.
 *
 * Arguments:
 * 0: Settings <HASHMAP>
 * 1: Radius preview center ATL <ARRAY>
 * 2: Include the countdown row <BOOL>
 *
 * Return Value:
 * [rows, settings keys in row order] <ARRAY>
 *
 * Example:
 * [call root_effects_emp_fnc_empDefaults, getPosATL player, true] call root_effects_emp_fnc_empDialogRows
 */

params [["_d", createHashMap, [createHashMap]], ["_pos", [0, 0, 0], [[]]], ["_countdown", true, [true]]];

private _modes = [LLSTRING(ModeOff), LLSTRING(ModeDisable), LLSTRING(ModeDestroy)];
private _rows = [];
private _keys = [];
private _fnc_add = {
    params ["_key", "_row"];
    _keys pushBack _key;
    _rows pushBack _row;
};

["radius", ["SLIDER:RADIUS", [LLSTRING(AttrRadius), LLSTRING(AttrRadiusTooltip)], [10, 3000, _d get "radius", 0, _pos, [0.3, 0.6, 1, 1]]]] call _fnc_add;
["altitude", ["SLIDER", [LLSTRING(AttrAltitude), LLSTRING(AttrAltitudeTooltip)], [-1, 2000, _d get "altitude", 0]]] call _fnc_add;
if (_countdown) then {
    ["countdown", ["SLIDER", [LLSTRING(AttrCountdown), LLSTRING(AttrCountdownTooltip)], [0, 600, _d get "countdown", 0]]] call _fnc_add;
};
["linger", ["SLIDER", [LLSTRING(AttrLinger), LLSTRING(AttrLingerTooltip)], [-1, 3600, _d get "linger", 0]]] call _fnc_add;
["shockSpeed", ["SLIDER", [LLSTRING(AttrShockSpeed), LLSTRING(AttrShockSpeedTooltip)], [0, 1000, _d get "shockSpeed", 0]]] call _fnc_add;
["effectDelay", ["SLIDER", [LLSTRING(AttrEffectDelay), LLSTRING(AttrEffectDelayTooltip)], [0, 30, _d get "effectDelay", 1]]] call _fnc_add;
["vehicles", ["TOOLBOX", [LLSTRING(AttrVehicles), LLSTRING(AttrVehiclesTooltip)], [_d get "vehicles", 1, 3, _modes]]] call _fnc_add;
["aircraft", ["TOOLBOX", [LLSTRING(AttrAircraft), LLSTRING(AttrAircraftTooltip)], [_d get "aircraft", 1, 3, _modes]]] call _fnc_add;
["uavs", ["TOOLBOX", [LLSTRING(AttrUavs), LLSTRING(AttrUavsTooltip)], [_d get "uavs", 1, 3, [LLSTRING(ModeOff), LLSTRING(ModeDisconnect), LLSTRING(ModeCrash)]]]] call _fnc_add;
["lamps", ["TOOLBOX", [LLSTRING(AttrLamps), LLSTRING(AttrLampsTooltip)], [_d get "lamps", 1, 3, [LLSTRING(ModeOff), LLSTRING(ModeLampsOff), LLSTRING(ModeBroken)]]]] call _fnc_add;
["gear", ["TOOLBOX", [LLSTRING(AttrGear), LLSTRING(AttrGearTooltip)], [_d get "gear", 1, 3, [LLSTRING(ModeOff), LLSTRING(ModeSuppress), LLSTRING(ModeFry)]]]] call _fnc_add;
["ai", ["TOOLBOX:YESNO", [LLSTRING(AttrAi), LLSTRING(AttrAiTooltip)], _d get "ai"]] call _fnc_add;
["radios", ["TOOLBOX:YESNO", [LLSTRING(AttrRadios), LLSTRING(AttrRadiosTooltip)], _d get "radios"]] call _fnc_add;
["channels", ["TOOLBOX:YESNO", [LLSTRING(AttrChannels), LLSTRING(AttrChannelsTooltip)], _d get "channels"]] call _fnc_add;
["fuelDrain", ["SLIDER:PERCENT", [LLSTRING(AttrFuelDrain), LLSTRING(AttrFuelDrainTooltip)], [0, 1, _d get "fuelDrain", 0]]] call _fnc_add;
["restore", ["TOOLBOX:YESNO", [LLSTRING(AttrRestore), LLSTRING(AttrRestoreTooltip)], _d get "restore"]] call _fnc_add;
["grace", ["SLIDER", [LLSTRING(AttrGrace), LLSTRING(AttrGraceTooltip)], [0, 60, _d get "grace", 0]]] call _fnc_add;
["warnGround", ["SLIDER", [LLSTRING(AttrWarnGround), LLSTRING(AttrWarnTooltip)], [0, 500, _d get "warnGround", 0]]] call _fnc_add;
["warnHeli", ["SLIDER", [LLSTRING(AttrWarnHeli), LLSTRING(AttrWarnTooltip)], [0, 2000, _d get "warnHeli", 0]]] call _fnc_add;
["warnPlane", ["SLIDER", [LLSTRING(AttrWarnPlane), LLSTRING(AttrWarnTooltip)], [0, 5000, _d get "warnPlane", 0]]] call _fnc_add;
["visuals", ["TOOLBOX:YESNO", [LLSTRING(AttrVisuals), LLSTRING(AttrVisualsTooltip)], _d get "visuals"]] call _fnc_add;
["chargeGlow", ["TOOLBOX:YESNO", [LLSTRING(AttrChargeGlow), LLSTRING(AttrChargeGlowTooltip)], _d get "chargeGlow"]] call _fnc_add;
["shake", ["TOOLBOX:YESNO", [LLSTRING(AttrShake), LLSTRING(AttrShakeTooltip)], _d get "shake"]] call _fnc_add;
["hud", ["TOOLBOX:YESNO", [LLSTRING(AttrHud), LLSTRING(AttrHudTooltip)], _d get "hud"]] call _fnc_add;
["dome", ["TOOLBOX:YESNO", [LLSTRING(AttrDome), LLSTRING(AttrDomeTooltip)], _d get "dome"]] call _fnc_add;
["domeColor", ["COLOR", [LLSTRING(AttrDomeColor), LLSTRING(AttrDomeColorTooltip)], _d get "domeColor"]] call _fnc_add;
["domeAlpha", ["SLIDER:PERCENT", [LLSTRING(AttrDomeAlpha), LLSTRING(AttrDomeAlphaTooltip)], [0.01, 1, _d get "domeAlpha", 0]]] call _fnc_add;
["domeShimmer", ["TOOLBOX:YESNO", [LLSTRING(AttrDomeShimmer), LLSTRING(AttrDomeShimmerTooltip)], _d get "domeShimmer"]] call _fnc_add;
["domeLightning", ["TOOLBOX:YESNO", [LLSTRING(AttrDomeLightning), LLSTRING(AttrDomeLightningTooltip)], _d get "domeLightning"]] call _fnc_add;
["domeMirage", ["TOOLBOX:YESNO", [LLSTRING(AttrDomeMirage), LLSTRING(AttrDomeMirageTooltip)], _d get "domeMirage"]] call _fnc_add;
["endMode", ["TOOLBOX", [LLSTRING(AttrEndMode), LLSTRING(AttrEndModeTooltip)], [_d get "endMode", 1, 2, [LLSTRING(EndFade), LLSTRING(EndImplode)]]]] call _fnc_add;
["implodeBlast", ["TOOLBOX", [LLSTRING(AttrImplodeBlast), LLSTRING(AttrImplodeBlastTooltip)], [_d get "implodeBlast", 1, 3, [LLSTRING(ModeOff), LLSTRING(BlastSmall), LLSTRING(BlastLarge)]]]] call _fnc_add;
["flickerGear", ["TOOLBOX:YESNO", [LLSTRING(AttrFlickerGear), LLSTRING(AttrFlickerGearTooltip)], _d get "flickerGear"]] call _fnc_add;
["flickerVehicles", ["TOOLBOX:YESNO", [LLSTRING(AttrFlickerVehicles), LLSTRING(AttrFlickerVehiclesTooltip)], _d get "flickerVehicles"]] call _fnc_add;
["flickerLamps", ["TOOLBOX:YESNO", [LLSTRING(AttrFlickerLamps), LLSTRING(AttrFlickerLampsTooltip)], _d get "flickerLamps"]] call _fnc_add;
["flickerOnMin", ["SLIDER", [LLSTRING(AttrFlickerOnMin), LLSTRING(AttrFlickerOnTooltip)], [0.1, 60, _d get "flickerOnMin", 1]]] call _fnc_add;
["flickerOnMax", ["SLIDER", [LLSTRING(AttrFlickerOnMax), LLSTRING(AttrFlickerOnTooltip)], [0.1, 60, _d get "flickerOnMax", 1]]] call _fnc_add;
["flickerOffMin", ["SLIDER", [LLSTRING(AttrFlickerOffMin), LLSTRING(AttrFlickerOffTooltip)], [0.1, 60, _d get "flickerOffMin", 1]]] call _fnc_add;
["flickerOffMax", ["SLIDER", [LLSTRING(AttrFlickerOffMax), LLSTRING(AttrFlickerOffTooltip)], [0.1, 60, _d get "flickerOffMax", 1]]] call _fnc_add;
["marker", ["TOOLBOX", [LLSTRING(AttrMarker), LLSTRING(AttrMarkerTooltip)], [_d get "marker", 1, 3, [LLSTRING(ModeOff), LLSTRING(MarkerArea), LLSTRING(MarkerLabel)]]]] call _fnc_add;
["markerSync", ["TOOLBOX:YESNO", [LLSTRING(AttrMarkerSync), LLSTRING(AttrMarkerSyncTooltip)], _d get "markerSync"]] call _fnc_add;
["beep", ["TOOLBOX:YESNO", [LLSTRING(AttrBeep), LLSTRING(AttrBeepTooltip)], _d get "beep"]] call _fnc_add;
["timer3D", ["TOOLBOX:YESNO", [LLSTRING(AttrTimer3D), LLSTRING(AttrTimer3DTooltip)], _d get "timer3D"]] call _fnc_add;
["timerHint", ["TOOLBOX:YESNO", [LLSTRING(AttrTimerHint), LLSTRING(AttrTimerHintTooltip)], _d get "timerHint"]] call _fnc_add;
["interaction", ["TOOLBOX", [LLSTRING(AttrInteraction), LLSTRING(AttrInteractionTooltip)], [_d get "interaction", 1, 4, [LLSTRING(ModeOff), LLSTRING(InteractionAction), LLSTRING(InteractionAce), LLSTRING(InteractionBoth)]]]] call _fnc_add;
["holdTime", ["SLIDER", [LLSTRING(AttrHoldTime), LLSTRING(AttrHoldTimeTooltip)], [0, 120, _d get "holdTime", 0]]] call _fnc_add;
["interactDistance", ["SLIDER", [LLSTRING(AttrInteractDistance), LLSTRING(AttrInteractDistanceTooltip)], [1, 12, _d get "interactDistance", 1]]] call _fnc_add;
["requiredItem", ["EDIT", [LLSTRING(AttrRequiredItem), LLSTRING(AttrRequiredItemTooltip)], _d get "requiredItem"]] call _fnc_add;
["abortCountdown", ["TOOLBOX:YESNO", [LLSTRING(AttrAbort), LLSTRING(AttrAbortTooltip)], _d get "abortCountdown"]] call _fnc_add;
["endOnDestroyed", ["TOOLBOX:YESNO", [LLSTRING(AttrEndDestroyed), LLSTRING(AttrEndDestroyedTooltip)], _d get "endOnDestroyed"]] call _fnc_add;
["itemsExtra", ["EDIT", [LLSTRING(AttrItemsExtra), LLSTRING(AttrItemsExtraTooltip)], _d get "itemsExtra"]] call _fnc_add;
["itemsImmune", ["EDIT", [LLSTRING(AttrItemsImmune), LLSTRING(AttrItemsImmuneTooltip)], _d get "itemsImmune"]] call _fnc_add;
["vehiclesImmune", ["EDIT", [LLSTRING(AttrVehiclesImmune), LLSTRING(AttrVehiclesImmuneTooltip)], _d get "vehiclesImmune"]] call _fnc_add;

[_rows, _keys]
