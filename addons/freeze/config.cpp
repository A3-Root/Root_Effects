#include "script_component.hpp"

class CfgPatches
{
	class root_effects_freeze
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
		units[] = {"Freeze_Module"};
		weapons[] = {};
	};
};


class CfgFunctions
{
	class Root
	{
		tag = "Root";
		class RootFreezeCategory
		{
			file = QPATHTOF(functions);
			class moduleFreezePlayers {};
			class freezePlayersServer {};
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
	class Freeze_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Freeze_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleFreezePlayers";
		displayName = CSTRING(ModuleFreeze);
	};
};
