#include "script_component.hpp"

class CfgPatches
{
	class root_effects_fallstar
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
		units[] = {"Fallstar_Module"};
		weapons[] = {};
	};
};


class CfgFunctions
{
	class Root
	{
		class RootFallstarCategory
		{
			class Fallstar {file = QPATHTOF(functions\init_fallstar.sqf);};
			class FallstarFallingIni {file = QPATHTOF(functions\fallstar_fallingstar_ini.sqf);};
			class FallstarFalling {file = QPATHTOF(functions\fallstar_fallingstar.sqf);};
			class FallstarHunt {file = QPATHTOF(functions\fallstar_hunt.sqf);};
			class FallstarLumina {file = QPATHTOF(functions\fallstar_lumina.sqf);};
			class FallstarMeteorEnd {file = QPATHTOF(functions\fallstar_meteor_end_blast.sqf);};
			class FallstarMeteorBlast {file = QPATHTOF(functions\fallstar_meteor_ini_blast.sqf);};
			class FallstarMeteorIni {file = QPATHTOF(functions\fallstar_meteor_ini.sqf);};
			class FallstarMeteor {file = QPATHTOF(functions\fallstar_meteor.sqf);};
			class FallstarMeteorEffect {file = QPATHTOF(functions\fallstar_meteoreffect.sqf);};
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

class CfgVehicles
{
	class zen_modules_moduleBase;
	class Fallstar_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Fallstar_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Fallstar";
		displayName = CSTRING(ModuleFallstar);
	};
};
