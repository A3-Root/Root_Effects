#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleLaserStrike);
PREP(moduleLaserStrike3DEN);
PREP(laserStart);
PREP(laserLocal);
PREP(moduleNapalmStrike);
PREP(moduleNapalmStrike3DEN);
PREP(napalmStart);
PREP(napalmIgnite);
PREP(napalmStartLocal);
PREP(moduleCarpetStrike);
PREP(moduleCarpetStrike3DEN);
PREP(carpetStart);
PREP(carpetSoundLocal);
PREP(moduleSingularity);
PREP(moduleSingularity3DEN);
PREP(singularityStart);
PREP(singularityLocal);
PREP(singularityFlingLocal);
