#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleMeteorsComets);
PREP(moduleMeteorsComets3DEN);
PREP(meteorsStart);
PREP(cometsStart);
PREP(pickTarget);
PREP(spawnMeteor);
PREP(spawnComet);
PREP(meteorLocal);
PREP(meteorImpactLocal);
PREP(cometLocal);
