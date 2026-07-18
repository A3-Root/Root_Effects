#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleCreateFeed);
PREP(moduleCreateFeed3DEN);
PREP(moduleModifyFeed);
PREP(moduleDeleteFeed);
PREP(moduleKillAll);

PREP(dialogCreateFull);
PREP(dialogDroneSource);
PREP(dialogScreenSource);
PREP(dialogModify);
PREP(dialogDelete);

PREP(serverCreateFeed);
PREP(serverDeleteFeed);
PREP(serverModifyFeed);
PREP(serverKillAll);
PREP(serverMonitor);
PREP(spawnDrone);

PREP(setupFeedLocal);
PREP(activateFeed);
PREP(deactivateFeed);
PREP(teardownFeedLocal);
PREP(getTurretAim);
PREP(addActions);
PREP(removeActions);

PREP(getDroneList);
PREP(getScreenList);
