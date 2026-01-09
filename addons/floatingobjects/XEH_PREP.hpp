// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(Floating,init_float.sqf);
PREP_ALIAS(Floating);
PREP_ROOT(FloatingMain,float_main.sqf);
PREP_ALIAS(FloatingMain);
PREP_ROOT(FloatingObj,float_obj.sqf);
PREP_ALIAS(FloatingObj);
