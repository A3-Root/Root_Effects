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
		tag = "Root";
		class RootFloatingCategory
		{
			file = QPATHTOF(functions);
			class moduleFloatingObjects {};
			class floatingObjectsServer {};
			class animateFloatingObject {};
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
		function = "Root_fnc_moduleFloatingObjects";
		displayName = CSTRING(ModuleFloating);
	};
};
