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
	class Root
	{
		class RootAmbientCategory
		{
			class LocalSound {file = QPATHTOF(functions\local_sound.sqf);};
			class Aurora {file = QPATHTOF(functions\init_ambient_aurora.sqf);};
			class AuroraMain {file = QPATHTOF(functions\aurora_main.sqf);};
			class AuroraSfx {file = QPATHTOF(functions\aurora_SFX.sqf);};
			class Firefly {file = QPATHTOF(functions\init_ambient_firefly.sqf);};
			class FireflyMain {file = QPATHTOF(functions\firefly_main.sqf);};
			class FireflySfx {file = QPATHTOF(functions\firefly_SFX.sqf);};
			class Rupture {file = QPATHTOF(functions\init_ambient_rupture.sqf);};
			class RuptureMain {file = QPATHTOF(functions\rupture_main.sqf);};
			class RuptureSfx {file = QPATHTOF(functions\rupture_SFX.sqf);};
			class Sparks {file = QPATHTOF(functions\init_ambient_sparks.sqf);};
			class SparksMain {file = QPATHTOF(functions\sparky_main.sqf);};
			class SparksEffects {file = QPATHTOF(functions\spark_effect.sqf);};
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
		function = "Root_fnc_Firefly";
		displayName = CSTRING(ModuleFirefly);
	};
	class Aurora_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Aurora_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Aurora";
		displayName = CSTRING(ModuleAurora);
	};
	class Rupture_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Rupture_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Rupture";
		displayName = CSTRING(ModuleRupture);
	};
	class Sparks_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Sparks_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Sparks";
		displayName = CSTRING(ModuleSparks);
	};
};
