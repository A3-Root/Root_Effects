// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(Fallstar,init_fallstar.sqf);
PREP_ALIAS(Fallstar);
PREP_ROOT(FallstarFallingIni,fallstar_fallingstar_ini.sqf);
PREP_ALIAS(FallstarFallingIni);
PREP_ROOT(FallstarFalling,fallstar_fallingstar.sqf);
PREP_ALIAS(FallstarFalling);
PREP_ROOT(FallstarHunt,fallstar_hunt.sqf);
PREP_ALIAS(FallstarHunt);
PREP_ROOT(FallstarLumina,fallstar_lumina.sqf);
PREP_ALIAS(FallstarLumina);
PREP_ROOT(FallstarMeteorEnd,fallstar_meteor_end_blast.sqf);
PREP_ALIAS(FallstarMeteorEnd);
PREP_ROOT(FallstarMeteorBlast,fallstar_meteor_ini_blast.sqf);
PREP_ALIAS(FallstarMeteorBlast);
PREP_ROOT(FallstarMeteorIni,fallstar_meteor_ini.sqf);
PREP_ALIAS(FallstarMeteorIni);
PREP_ROOT(FallstarMeteor,fallstar_meteor.sqf);
PREP_ALIAS(FallstarMeteor);
PREP_ROOT(FallstarMeteorEffect,fallstar_meteoreffect.sqf);
PREP_ALIAS(FallstarMeteorEffect);
