#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleEmp);
PREP(moduleEmp3DEN);
PREP(empStart);
PREP(empLocal);
PREP(empVehicleLocal);
PREP(empLampsLocal);
PREP(empUnitLocal);
