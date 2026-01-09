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
		tag = "Root";
		class RootBattleCategory
		{
			file = QPATHTOF(functions);
			class moduleAntiAirBarrage {};
			class antiAirBarrageServer {};
			class antiAirBarrageEffects {};
			class moduleArtilleryBarrage {};
			class artilleryBarrageServer {};
			class artilleryBarrageEffects {};
			class moduleMissileLauncher {};
			class missileLauncherServer {};
			class missileLauncherEffects {};
			class moduleSearchlight {};
			class searchlightServer {};
			class searchlightEffects {};
			class moduleTracerFire {};
			class tracerFireServer {};
			class tracerFireEffects {};
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
		function = "Root_fnc_moduleAntiAirBarrage";
		displayName = CSTRING(ModuleAAA);
	};
	class Ground_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Ground_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleArtilleryBarrage";
		displayName = CSTRING(ModuleGround);
	};
	class Missiles_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Missiles_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleMissileLauncher";
		displayName = CSTRING(ModuleMissiles);
	};
	class Search_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Search_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleSearchlight";
		displayName = CSTRING(ModuleSearch);
	};
	class Tracers_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Tracers_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleTracerFire";
		displayName = CSTRING(ModuleTracers);
	};
};
