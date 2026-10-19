#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(create);
PREP(disable);
PREP(isInside);
PREP(modify);
PREP(moduleEmp);
PREP(moduleEmp3DEN);
PREP(empAcreSignal);
PREP(empApply);
PREP(empCanDisable);
PREP(empCap);
PREP(empClamp);
PREP(empCountdownLocal);
PREP(empDefaults);
PREP(empDetonateLocal);
PREP(empDomeLocal);
PREP(empFieldLocal);
PREP(empFry);
PREP(empInteraction);
PREP(empInZone);
PREP(empIsElectronic);
PREP(empLampsLocal);
PREP(empLoop);
PREP(empServer);
PREP(empStart);
PREP(empSuppressLocal);
PREP(empWarnLocal);
PREP(moduleModifyEmp);
PREP(moduleModifyEmp3DEN);
PREP(empApproachLocal);
PREP(empBoundaryDist);
PREP(empDialogRows);
PREP(empSparksLocal);
