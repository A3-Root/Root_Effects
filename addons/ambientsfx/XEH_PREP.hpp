#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleFireflies);
PREP(moduleFireflies3DEN);
PREP(firefliesStart);
PREP(firefliesStartLocal);
PREP(moduleAurora);
PREP(moduleAurora3DEN);
PREP(auroraStart);
PREP(auroraStartLocal);
PREP(moduleRupture);
PREP(moduleRupture3DEN);
PREP(ruptureStart);
PREP(ruptureStartLocal);
PREP(moduleSparks);
PREP(moduleSparks3DEN);
PREP(sparksStart);
PREP(sparkBurstLocal);
PREP(moduleBirdSwarm);
PREP(moduleBirdSwarm3DEN);
PREP(birdSwarmStart);
