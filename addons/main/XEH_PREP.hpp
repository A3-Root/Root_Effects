#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(registerEffect);
PREP(startEffect);
PREP(stopEffect);
PREP(doDamage);
PREP(doDamageLocal);
PREP(doHitPointDamage);
PREP(doHitPointDamageLocal);
PREP(isEffectEnabled);
PREP(log);
PREP(serverEventLogged);
PREP(moduleTerminate);
PREP(registerLocalObject);
PREP(terminateDialog);
