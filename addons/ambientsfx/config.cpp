#include "script_component.hpp"

class CfgPatches
{
	class root_effects_ambientsfx
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
		units[] = {"Fireflies_Module", "Aurora_Module", "Rupture_Module", "Sparks_Module"};
		weapons[] = {};
	};
};


class CfgFunctions
{
	class root_effects_ambientsfx
	{
		tag = "root_effects_ambientsfx";
		class RootAmbientCategory
		{
			file = QPATHTOF(functions);
			class playLocalSound {};
			class moduleAurora {};
			class auroraServer {};
			class auroraEffects {};
			class moduleFirefly {};
			class fireflyServer {};
			class fireflyEffects {};
			class moduleRupture {};
			class ruptureServer {};
			class ruptureEffects {};
			class moduleSparks {};
			class sparksServer {};
			class sparksEffectsLoop {};
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
	class Fireflies_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Fireflies_Module";
		category = "ROOT_EFFECTS";
		function = "root_effects_ambientsfx_fnc_moduleFirefly";
		displayName = CSTRING(ModuleFirefly);
	};
	class Aurora_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Aurora_Module";
		category = "ROOT_EFFECTS";
		function = "root_effects_ambientsfx_fnc_moduleAurora";
		displayName = CSTRING(ModuleAurora);
	};
	class Rupture_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Rupture_Module";
		category = "ROOT_EFFECTS";
		function = "root_effects_ambientsfx_fnc_moduleRupture";
		displayName = CSTRING(ModuleRupture);
	};
	class Sparks_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Sparks_Module";
		category = "ROOT_EFFECTS";
		function = "root_effects_ambientsfx_fnc_moduleSparks";
		displayName = CSTRING(ModuleSparks);
	};
};
