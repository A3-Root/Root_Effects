#include "script_component.hpp"

class CfgPatches
{
	class root_effects_fireworks
	{
		name = COMPONENT_NAME;
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		requiredVersion = REQUIRED_VERSION;
		addonRootClass = "root_effects_main";
		requiredAddons[] = {"A3_Modules_F_Curator", "cba_main", "root_effects_main", "zen_custom_modules"};
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
			class Fireworks {file = QPATHTOF(functions\init_fireworks.sqf);};
			class FireworksMain {file = QPATHTOF(functions\fireworks_main.sqf);};
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
	class Fireworks_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "News_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Fireworks";
		displayName = CSTRING(ModuleFireworks);
	};
};
