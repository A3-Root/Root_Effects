#include "script_component.hpp"

class CfgPatches
{
	class root_effects_fallstar
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
		units[] = {"Fallstar_Module"};
		weapons[] = {};
	};
};


class CfgFunctions
{
	class root_effects_fallstar
	{
		tag = "root_effects_fallstar";
		class RootFallstarCategory
		{
			file = QPATHTOF(functions);
			class moduleMeteorsComets {};
			class startCometSpawner {};
			class spawnComet {};
			class updateMeteorCometTarget {};
			class cometGlowEffects {};
			class meteorImpactEffects {};
			class meteorFlashEffects {};
			class startMeteorSpawner {};
			class spawnMeteor {};
			class meteorTrailEffects {};
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
	class Fallstar_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Fallstar_Module";
		category = "ROOT_EFFECTS";
		function = "root_effects_fallstar_fnc_moduleMeteorsComets";
		displayName = CSTRING(ModuleFallstar);
	};
};
