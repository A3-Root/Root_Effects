// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(AAA,init_ambient_aaa.sqf);
PREP_ALIAS(AAA);
PREP_ROOT(AAAMain,aaa_main.sqf);
PREP_ALIAS(AAAMain);
PREP_ROOT(AAAEffects,aaa_effects.sqf);
PREP_ALIAS(AAAEffects);
PREP_ROOT(Ground,init_ambient_ground.sqf);
PREP_ALIAS(Ground);
PREP_ROOT(GroundMain,ground_main.sqf);
PREP_ALIAS(GroundMain);
PREP_ROOT(GroundEffects,ground_effects.sqf);
PREP_ALIAS(GroundEffects);
PREP_ROOT(Missiles,init_ambient_missiles.sqf);
PREP_ALIAS(Missiles);
PREP_ROOT(MissilesMain,missiles_main.sqf);
PREP_ALIAS(MissilesMain);
PREP_ROOT(MissilesEffects,missiles_effects.sqf);
PREP_ALIAS(MissilesEffects);
PREP_ROOT(Search,init_ambient_search.sqf);
PREP_ALIAS(Search);
PREP_ROOT(SearchMain,search_main.sqf);
PREP_ALIAS(SearchMain);
PREP_ROOT(SearchEffects,search_effects.sqf);
PREP_ALIAS(SearchEffects);
PREP_ROOT(Tracers,init_ambient_tracers.sqf);
PREP_ALIAS(Tracers);
PREP_ROOT(TracersMain,tracers_main.sqf);
PREP_ALIAS(TracersMain);
PREP_ROOT(TracersEffects,tracers_effects.sqf);
PREP_ALIAS(TracersEffects);
