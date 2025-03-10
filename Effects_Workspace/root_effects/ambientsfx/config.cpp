class CfgPatches
{
	class Root_Ambient_Effect
	{
		name = "Root's Effects";
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		addonRootClass = "Root_Effects";
		requiredAddons[] = {"A3_Modules_F_Curator", "cba_main", "Root_Effects", "zen_custom_modules"};
		requiredVersion = 0.1;
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
			class Aurora {file = "root_effects\ambientsfx\functions\init_ambient_aurora.sqf";};
			class AuroraSfx {file = "root_effects\ambientsfx\functions\aurora_SFX.sqf";};
			class Firefly {file = "root_effects\ambientsfx\functions\init_ambient_firefly.sqf";};
			class FireflyMain {file = "root_effects\ambientsfx\functions\firefly_main.sqf";};
			class FireflySfx {file = "root_effects\ambientsfx\functions\firefly_SFX.sqf";};
			class Rupture {file = "root_effects\ambientsfx\functions\init_ambient_rupture.sqf";};
			class RuptureMain {file = "root_effects\ambientsfx\functions\rupture_main.sqf";};
			class RuptureSfx {file = "root_effects\ambientsfx\functions\rupture_SFX.sqf";};
			class Sparks {file = "root_effects\ambientsfx\functions\init_ambient_sparks.sqf";};
			class SparksMain {file = "root_effects\ambientsfx\functions\sparky_main.sqf";};
			class SparksEffects {file = "root_effects\ambientsfx\functions\spark_effect.sqf";};
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
	class Fireflies_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Fireflies_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Firefly";
		displayName = "Ambient Firefly";
	};
	class Aurora_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Aurora_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Aurora";
		displayName = "Aurora Borealis";
	};
	class Rupture_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Rupture_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Rupture";
		displayName = "Spacetime Rupture";
	};
	class Sparks_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Sparks_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Sparks";
		displayName = "Ambient Sparks";
	};
};
