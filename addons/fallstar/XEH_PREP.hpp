#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleMeteorsComets);
PREP(startCometSpawner);
PREP(spawnComet);
PREP(updateMeteorCometTarget);
PREP(cometGlowEffects);
PREP(meteorImpactEffects);
PREP(meteorFlashEffects);
PREP(startMeteorSpawner);
PREP(spawnMeteor);
PREP(meteorTrailEffects);
