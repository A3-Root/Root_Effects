class CfgPatches
{
	class Root_Fireworks_Effect
	{
		name = "Root's Effects";
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		requiredVersion = 0.1;
		addonRootClass = "Root_Effects";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Effects", "zen_custom_modules"};
		units[] = {"Fireworks_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootFireworksCategory
		{
			class Fireworks {file = "root_effects\fireworks\functions\init_fireworks.sqf";};
			class FireworksMain {file = "root_effects\fireworks\functions\fireworks_main.sqf";};
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
	class Fireworks_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "News_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Fireworks";
		displayName = "Fireworks Module";
	};
};