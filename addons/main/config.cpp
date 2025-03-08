class CfgPatches
{
	class Root_Effects
	{
		name = "Root's Effects";
		author = "Root";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","zen_custom_modules"};
		requiredVersion = 0.1;
		units[] = {"Floating_Module", "Fallstar_Module", "UFO_Module", "Seeker_Module", "Cropcircle_Module", "Termination_Module", "Volcano_Module", "AAA_Module", "Missiles_Module", "Ground_Module", "Tracers_Module", "Search_Module", "Freeze_Module", "News_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootTerminationCategory
		{
			class Termination {file = "\Root_Effects\term_entities.sqf";};
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
	class Termination_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Termination_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Termination";
		displayName = "Terminate Effects";
	};
};