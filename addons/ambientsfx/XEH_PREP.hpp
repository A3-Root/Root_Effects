// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(LocalSound,local_sound.sqf);
PREP_ALIAS(LocalSound);
PREP_ROOT(Aurora,init_ambient_aurora.sqf);
PREP_ALIAS(Aurora);
PREP_ROOT(AuroraMain,aurora_main.sqf);
PREP_ALIAS(AuroraMain);
PREP_ROOT(AuroraSfx,aurora_SFX.sqf);
PREP_ALIAS(AuroraSfx);
PREP_ROOT(Firefly,init_ambient_firefly.sqf);
PREP_ALIAS(Firefly);
PREP_ROOT(FireflyMain,firefly_main.sqf);
PREP_ALIAS(FireflyMain);
PREP_ROOT(FireflySfx,firefly_SFX.sqf);
PREP_ALIAS(FireflySfx);
PREP_ROOT(Rupture,init_ambient_rupture.sqf);
PREP_ALIAS(Rupture);
PREP_ROOT(RuptureMain,rupture_main.sqf);
PREP_ALIAS(RuptureMain);
PREP_ROOT(RuptureSfx,rupture_SFX.sqf);
PREP_ALIAS(RuptureSfx);
PREP_ROOT(Sparks,init_ambient_sparks.sqf);
PREP_ALIAS(Sparks);
PREP_ROOT(SparksMain,sparky_main.sqf);
PREP_ALIAS(SparksMain);
PREP_ROOT(SparksEffects,spark_effect.sqf);
PREP_ALIAS(SparksEffects);
