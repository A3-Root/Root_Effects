class CfgPatches
{
	class Root_Freeze_Effect
	{
		name = "Root's Effects";
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		addonRootClass = "Root_Effects";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Effects", "zen_custom_modules"};
		requiredVersion = 0.1;
		units[] = {"Freeze_Module"};
		weapons[] = {};
	};
};


class CfgFunctions
{
	class Root
	{
		class RootFreezeCategory
		{
			class Freeze {file = "root_effects\freeze\functions\init_freeze.sqf";};
			class FreezeMain {file = "root_effects\freeze\functions\freeze_main.sqf";};
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
	class Freeze_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Freeze_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Freeze";
		displayName = "Freeze Players";
	};
};