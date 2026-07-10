#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleFireworks);
PREP(moduleFireworks3DEN);
PREP(fireworksStart);
PREP(fireworksStartLocal);
PREP(fireworkBurstLocal);
