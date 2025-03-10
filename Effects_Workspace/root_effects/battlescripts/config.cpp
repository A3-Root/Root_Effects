class CfgPatches
{
	class Root_Battle_Effect
	{
		name = "Root's Effects";
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		addonRootClass = "Root_Effects";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Effects","zen_custom_modules"};
		requiredVersion = 0.1;
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
			class AAA {file = "root_effects\battlescripts\functions\init_ambient_aaa.sqf";};
			class Ground {file = "root_effects\battlescripts\functions\init_ambient_ground.sqf";};
			class Missiles {file = "root_effects\battlescripts\functions\init_ambient_missiles.sqf";};
			class Search {file = "root_effects\battlescripts\functions\init_ambient_search.sqf";};
			class SearchEffects {file = "root_effects\battlescripts\functions\search_effects.sqf";};
			class Tracers {file = "root_effects\battlescripts\functions\init_ambient_tracers.sqf";};
			class TracersEffects {file = "root_effects\battlescripts\functions\tracers_effects.sqf";};
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

class CfgVehicles
{
	class zen_modules_moduleBase;
	class AAA_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "AAA_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_AAA";
		displayName = "Anti Air (AA) Barrage";
	};
	class Ground_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Ground_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Ground";
		displayName = "Artillery Barrage";
	};
	class Missiles_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Missiles_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Missiles";
		displayName = "Missile Launcher";
	};
	class Search_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Search_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Search";
		displayName = "Searchlights";
	};
	class Tracers_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Tracers_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Tracers";
		displayName = "Tracers";
	};
};
