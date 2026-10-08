#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleVolcano);
PREP(moduleVolcano3DEN);
PREP(volcanoStart);
PREP(volcanoStartLocal);
PREP(volcanoBurstLocal);
PREP(volcanoIsProtected);
PREP(moduleAvalanche);
PREP(moduleAvalanche3DEN);
PREP(avalancheStart);
PREP(avalancheRocks);
PREP(avalancheRockPaths);
PREP(avalancheLocal);
