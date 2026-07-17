#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleFreezePlayers);
PREP(moduleFreezePlayers3DEN);
PREP(freezeApply);
PREP(freezeLocal);
PREP(moduleCryoBlast);
PREP(moduleCryoBlast3DEN);
PREP(cryoBlastStart);
PREP(cryoBlastFreeze);
PREP(cryoBlastLocal);
