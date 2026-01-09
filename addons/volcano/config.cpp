#include "script_component.hpp"

class CfgPatches
{
	class root_effects_volcano
	{
		name = COMPONENT_NAME;
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		addonRootClass = "root_effects_main";
		requiredAddons[] = {"A3_Modules_F_Curator", "cba_main", "root_effects_main", "zen_custom_modules"};
		requiredVersion = REQUIRED_VERSION;
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
			class Volcano {file = QPATHTOF(functions\init_volcano.sqf);};
			class VolcanoBlow {file = QPATHTOF(functions\volcano_blow.sqf);};
			class VolcanoCrater {file = QPATHTOF(functions\volcano_crater_SFX.sqf);};
			class VolcanoEffect {file = QPATHTOF(functions\volcano_effect.sqf);};
			class VolcanoFulger {file = QPATHTOF(functions\volcano_fulger_effect.sqf);};
			class VolcanoLava {file = QPATHTOF(functions\volcano_lava_flow.sqf);};
			class VolcanoMain {file = QPATHTOF(functions\volcano_main.sqf);};
			class VolcanoPuf {file = QPATHTOF(functions\volcano_puf.sqf);};
			class VolcanoRock {file = QPATHTOF(functions\volcano_rock_trail.sqf);};
			class VolcanoScantei {file = QPATHTOF(functions\volcano_scantei.sqf);};
			class VolcanoShije {file = QPATHTOF(functions\volcano_schije.sqf);};
			class VolcanoColumn {file = QPATHTOF(functions\volcano_smoke_column.sqf);};
			class VolcanoDamage {file = QPATHTOF(functions\volcano_unit_damage.sqf);};
		};
	};
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class ROOT_EFFECTS : NO_CATEGORY {
		displayName = CSTRING(CategoryName);
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
		displayName = CSTRING(ModuleVolcano);
	};
};
