#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleLightningStorm);
PREP(moduleLightningStorm3DEN);
PREP(lightningStart);
PREP(moduleAcidRain);
PREP(moduleAcidRain3DEN);
PREP(acidRainStart);
PREP(acidRainStartLocal);
PREP(moduleHeatMirage);
PREP(moduleHeatMirage3DEN);
PREP(mirageStart);
PREP(mirageStartLocal);
PREP(moduleWaterTint);
PREP(moduleWaterTint3DEN);
PREP(waterTintStart);
PREP(waterTintStartLocal);
