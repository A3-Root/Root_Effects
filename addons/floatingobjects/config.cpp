#include "script_component.hpp"

class CfgPatches
{
	class root_effects_floatingobjects
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
			class Floating {file = QPATHTOF(functions\init_float.sqf);};
			class FloatingMain {file = QPATHTOF(functions\float_main.sqf);};
			class FloatingObj {file = QPATHTOF(functions\float_obj.sqf);};
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

class CfgVehicles {
    class zen_modules_moduleBase;
	class Floating_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Floating_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Floating";
		displayName = CSTRING(ModuleFloating);
	};
};
