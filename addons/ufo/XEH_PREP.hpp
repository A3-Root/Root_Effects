#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleUfoEncounter);
PREP(moduleUfoSeeker);
PREP(moduleUfoCropCircle);
PREP(ufoChargingEffects);
PREP(createUfoCropCircle);
PREP(animateUfoCropCircle);
PREP(ufoCrossLighting);
PREP(ufoCrossFlyby);
PREP(ufoEncounterServer);
PREP(updateUfoTarget);
PREP(ufoLightChargeEffects);
PREP(ufoPulseEffects);
PREP(ufoSeekerServer);
PREP(ufoTravelEffects);
