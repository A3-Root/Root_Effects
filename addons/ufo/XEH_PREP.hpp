// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(UFO,init_ufo.sqf);
PREP_ALIAS(UFO);
PREP_ROOT(Seeker,init_seeker.sqf);
PREP_ALIAS(Seeker);
PREP_ROOT(Cropcircle,init_cropcircle.sqf);
PREP_ALIAS(Cropcircle);
PREP_ROOT(UFOCharging,ufo_charging_SFX.sqf);
PREP_ALIAS(UFOCharging);
PREP_ROOT(UFOCropCircle,ufo_crop_circle.sqf);
PREP_ALIAS(UFOCropCircle);
PREP_ROOT(UFOCropping,ufo_cropping.sqf);
PREP_ALIAS(UFOCropping);
PREP_ROOT(UFOCrossLit,ufo_cross_lit.sqf);
PREP_ALIAS(UFOCrossLit);
PREP_ROOT(UFOCross,ufo_cross.sqf);
PREP_ALIAS(UFOCross);
PREP_ROOT(UFOEncounter,ufo_encounter.sqf);
PREP_ALIAS(UFOEncounter);
PREP_ROOT(UFOHunt,ufo_hunt.sqf);
PREP_ALIAS(UFOHunt);
PREP_ROOT(UFOLightCharge,ufo_light_charge_sfx.sqf);
PREP_ALIAS(UFOLightCharge);
PREP_ROOT(UFOPuls,ufo_puls.sqf);
PREP_ALIAS(UFOPuls);
PREP_ROOT(UFOSeeker,ufo_seeker.sqf);
PREP_ALIAS(UFOSeeker);
PREP_ROOT(UFOTravel,ufo_travel_SFX.sqf);
PREP_ALIAS(UFOTravel);
