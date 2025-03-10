class CfgPatches
{
	class Root_Volcano_Effect
	{
		addonRootClass = "Root_Effects";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Effects","zen_custom_modules"};
		requiredVersion = 0.1;
		units[] = {"Volcano_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootVolcanoCategory
		{
			class Volcano {file = "\Root_Effects\Root_Volcano\AL_volcano\init_volcano.sqf";};
			class VolcanoBlow {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_blow.sqf";};
			class VolcanoCrater {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_crater_SFX.sqf";};
			class VolcanoEffect {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_effect.sqf";};
			class VolcanoFulger {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_fulger_effect.sqf";};
			class VolcanoLava {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_lava_flow.sqf";};
			class VolcanoMain {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_main.sqf";};
			class VolcanoPuf {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_puf.sqf";};
			class VolcanoRock {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_rock_trail.sqf";};
			class VolcanoScantei {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_scantei.sqf";};
			class VolcanoShije {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_schije.sqf";};
			class VolcanoColumn {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_smoke_column.sqf";};
			class VolcanoDamage {file = "\Root_Effects\Root_Volcano\AL_volcano\volcano_unit_damage.sqf";};
		};
	};
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class ROOT_EFFECTS : NO_CATEGORY {
		displayName = "Root's Effects";
	};
};

class CfgVehicles {
    class zen_modules_moduleBase;
	class Volcano_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Volcano_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Volcano";
		displayName = "Volcanic Eruption";
	};
};