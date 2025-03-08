class CfgPatches
{
	class Root_Floating_Effect
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
		units[] = {"Floating_Module"};
		weapons[] = {};
	};
};


class CfgFunctions
{
	class Root
	{
		class RootFloatingCategory
		{
			class Floating {file = "root_effects\floatingobjects\functions\init_float.sqf";};
			class FloatingMain {file = "root_effects\floatingobjects\functions\float_main.sqf";};
			class FloatingObj {file = "root_effects\floatingobjects\functions\float_obj.sqf";};
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
	class Floating_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Floating_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Floating";
		displayName = "Floating Objects";
	};
};