#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleAntiAirBarrage);
PREP(antiAirBarrageServer);
PREP(antiAirBarrageEffects);
PREP(moduleArtilleryBarrage);
PREP(artilleryBarrageServer);
PREP(artilleryBarrageEffects);
PREP(moduleMissileLauncher);
PREP(missileLauncherServer);
PREP(missileLauncherEffects);
PREP(moduleSearchlight);
PREP(searchlightServer);
PREP(searchlightEffects);
PREP(moduleTracerFire);
PREP(tracerFireServer);
PREP(tracerFireEffects);
