// Compile Root_fnc_* and alias to CBA-style QFUNC names for internal use.
#undef PREP
#define PREP_ROOT(funcName,fileName) [QPATHTOF(functions\fileName), QUOTE(TRIPLES(Root,fnc,funcName))] call CBA_fnc_compileFunction
#define PREP_ALIAS(funcName) missionNamespace setVariable [QFUNC(funcName), missionNamespace getVariable [QUOTE(TRIPLES(Root,fnc,funcName)), {}]]

PREP_ROOT(Volcano,init_volcano.sqf);
PREP_ALIAS(Volcano);
PREP_ROOT(VolcanoBlow,volcano_blow.sqf);
PREP_ALIAS(VolcanoBlow);
PREP_ROOT(VolcanoCrater,volcano_crater_SFX.sqf);
PREP_ALIAS(VolcanoCrater);
PREP_ROOT(VolcanoEffect,volcano_effect.sqf);
PREP_ALIAS(VolcanoEffect);
PREP_ROOT(VolcanoFulger,volcano_fulger_effect.sqf);
PREP_ALIAS(VolcanoFulger);
PREP_ROOT(VolcanoLava,volcano_lava_flow.sqf);
PREP_ALIAS(VolcanoLava);
PREP_ROOT(VolcanoMain,volcano_main.sqf);
PREP_ALIAS(VolcanoMain);
PREP_ROOT(VolcanoPuf,volcano_puf.sqf);
PREP_ALIAS(VolcanoPuf);
PREP_ROOT(VolcanoRock,volcano_rock_trail.sqf);
PREP_ALIAS(VolcanoRock);
PREP_ROOT(VolcanoScantei,volcano_scantei.sqf);
PREP_ALIAS(VolcanoScantei);
PREP_ROOT(VolcanoShije,volcano_schije.sqf);
PREP_ALIAS(VolcanoShije);
PREP_ROOT(VolcanoColumn,volcano_smoke_column.sqf);
PREP_ALIAS(VolcanoColumn);
PREP_ROOT(VolcanoDamage,volcano_unit_damage.sqf);
PREP_ALIAS(VolcanoDamage);
