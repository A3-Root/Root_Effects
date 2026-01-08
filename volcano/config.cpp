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
			class Volcano {file = "root_effects\volcano\functions\init_volcano.sqf";};
			class VolcanoBlow {file = "root_effects\volcano\functions\volcano_blow.sqf";};
			class VolcanoCrater {file = "root_effects\volcano\functions\volcano_crater_SFX.sqf";};
			class VolcanoEffect {file = "root_effects\volcano\functions\volcano_effect.sqf";};
			class VolcanoFulger {file = "root_effects\volcano\functions\volcano_fulger_effect.sqf";};
			class VolcanoLava {file = "root_effects\volcano\functions\volcano_lava_flow.sqf";};
			class VolcanoMain {file = "root_effects\volcano\functions\volcano_main.sqf";};
			class VolcanoPuf {file = "root_effects\volcano\functions\volcano_puf.sqf";};
			class VolcanoRock {file = "root_effects\volcano\functions\volcano_rock_trail.sqf";};
			class VolcanoScantei {file = "root_effects\volcano\functions\volcano_scantei.sqf";};
			class VolcanoShije {file = "root_effects\volcano\functions\volcano_schije.sqf";};
			class VolcanoColumn {file = "root_effects\volcano\functions\volcano_smoke_column.sqf";};
			class VolcanoDamage {file = "root_effects\volcano\functions\volcano_unit_damage.sqf";};
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