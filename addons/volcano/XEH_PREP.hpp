#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleVolcanoEruption);
PREP(volcanoBlastPuff);
PREP(volcanoCraterEffects);
PREP(volcanoEruptionEffects);
PREP(volcanoLightningEffects);
PREP(volcanoLavaFlow);
PREP(volcanoEruptionServer);
PREP(volcanoSmokePuff);
PREP(volcanoRockTrail);
PREP(volcanoSparkBurst);
PREP(volcanoShrapnelBurst);
PREP(volcanoSmokeColumn);
PREP(volcanoUnitDamage);
