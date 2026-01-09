#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(playLocalSound);
PREP(moduleAurora);
PREP(auroraServer);
PREP(auroraEffects);
PREP(moduleFirefly);
PREP(fireflyServer);
PREP(fireflyEffects);
PREP(moduleRupture);
PREP(ruptureServer);
PREP(ruptureEffects);
PREP(moduleSparks);
PREP(sparksServer);
PREP(sparksEffectsLoop);
