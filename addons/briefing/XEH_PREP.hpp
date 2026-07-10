#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleBriefingMap);
PREP(moduleBriefingMap3DEN);
PREP(briefingMapStart);
PREP(briefingMapStartLocal);
PREP(moduleBriefingTable);
PREP(moduleBriefingTable3DEN);
PREP(briefingTableStart);
PREP(briefingTableStartLocal);
