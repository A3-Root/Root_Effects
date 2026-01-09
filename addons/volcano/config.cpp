#include "script_component.hpp"

class CfgPatches
{
	class root_effects_volcano
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
		units[] = {"Volcano_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		tag = "Root";
		class RootVolcanoCategory
		{
			file = QPATHTOF(functions);
			class moduleVolcanoEruption {};
			class volcanoBlastPuff {};
			class volcanoCraterEffects {};
			class volcanoEruptionEffects {};
			class volcanoLightningEffects {};
			class volcanoLavaFlow {};
			class volcanoEruptionServer {};
			class volcanoSmokePuff {};
			class volcanoRockTrail {};
			class volcanoSparkBurst {};
			class volcanoShrapnelBurst {};
			class volcanoSmokeColumn {};
			class volcanoUnitDamage {};
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
	class Volcano_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Volcano_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleVolcanoEruption";
		displayName = CSTRING(ModuleVolcano);
	};
};
