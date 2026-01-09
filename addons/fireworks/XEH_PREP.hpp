// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(Fireworks,init_fireworks.sqf);
PREP_ALIAS(Fireworks);
PREP_ROOT(FireworksMain,fireworks_main.sqf);
PREP_ALIAS(FireworksMain);
