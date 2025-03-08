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
			class Volcano {file = "\Root_Effects\Root_Volcano\AL_volcano\init_volcano.sqf";};
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