#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleUfoEncounter);
PREP(moduleUfoEncounter3DEN);
PREP(moduleUfoSeeker);
PREP(moduleUfoSeeker3DEN);
PREP(moduleUfoCropCircle);
PREP(moduleUfoCropCircle3DEN);
PREP(encounterStart);
PREP(seekerStart);
PREP(cropCircleStart);
PREP(pickTarget);
PREP(crossFlyby);
PREP(crossLocal);
PREP(jumpLocal);
PREP(seekerLocal);
PREP(cropCircleLocal);
