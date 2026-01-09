#include "script_component.hpp"

class CfgPatches
{
	class root_effects_battlescripts
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
		units[] = {"AAA_Module", "Missiles_Module", "Ground_Module", "Tracers_Module", "Search_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootBattleCategory
		{
			class AAA {file = QPATHTOF(functions\init_ambient_aaa.sqf);};
			class AAAMain {file = QPATHTOF(functions\aaa_main.sqf);};
			class AAAEffects {file = QPATHTOF(functions\aaa_effects.sqf);};
			class Ground {file = QPATHTOF(functions\init_ambient_ground.sqf);};
			class GroundMain {file = QPATHTOF(functions\ground_main.sqf);};
			class GroundEffects {file = QPATHTOF(functions\ground_effects.sqf);};
			class Missiles {file = QPATHTOF(functions\init_ambient_missiles.sqf);};
			class MissilesMain {file = QPATHTOF(functions\missiles_main.sqf);};
			class MissilesEffects {file = QPATHTOF(functions\missiles_effects.sqf);};
			class Search {file = QPATHTOF(functions\init_ambient_search.sqf);};
			class SearchMain {file = QPATHTOF(functions\search_main.sqf);};
			class SearchEffects {file = QPATHTOF(functions\search_effects.sqf);};
			class Tracers {file = QPATHTOF(functions\init_ambient_tracers.sqf);};
			class TracersMain {file = QPATHTOF(functions\tracers_main.sqf);};
			class TracersEffects {file = QPATHTOF(functions\tracers_effects.sqf);};
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

class CfgVehicles
{
	class zen_modules_moduleBase;
	class AAA_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "AAA_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_AAA";
		displayName = CSTRING(ModuleAAA);
	};
	class Ground_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Ground_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Ground";
		displayName = CSTRING(ModuleGround);
	};
	class Missiles_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Missiles_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Missiles";
		displayName = CSTRING(ModuleMissiles);
	};
	class Search_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Search_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Search";
		displayName = CSTRING(ModuleSearch);
	};
	class Tracers_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Tracers_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Tracers";
		displayName = CSTRING(ModuleTracers);
	};
};
