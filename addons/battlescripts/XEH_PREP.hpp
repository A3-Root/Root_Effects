#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleAntiAirBarrage);
PREP(moduleAntiAirBarrage3DEN);
PREP(aaaStart);
PREP(aaaStartLocal);
PREP(aaaBurstLocal);
PREP(moduleArtilleryBarrage);
PREP(moduleArtilleryBarrage3DEN);
PREP(artilleryStart);
PREP(artilleryImpactLocal);
PREP(moduleMissileLauncher);
PREP(moduleMissileLauncher3DEN);
PREP(missilesStart);
PREP(missileLaunchLocal);
PREP(moduleSearchlight);
PREP(moduleSearchlight3DEN);
PREP(searchlightStart);
PREP(searchlightStartLocal);
PREP(moduleTracerFire);
PREP(moduleTracerFire3DEN);
PREP(tracersStart);
PREP(tracersStartLocal);
