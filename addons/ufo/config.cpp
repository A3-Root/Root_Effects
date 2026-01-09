#include "script_component.hpp"

class CfgPatches
{
	class root_effects_ufo
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
		units[] = {"UFO_Module", "Seeker_Module", "Cropcircle_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootUFOCategory
		{
			class UFO {file = QPATHTOF(functions\init_ufo.sqf);};
			class Seeker {file = QPATHTOF(functions\init_seeker.sqf);};
			class Cropcircle {file = QPATHTOF(functions\init_cropcircle.sqf);};
			class UFOCharging {file = QPATHTOF(functions\ufo_charging_SFX.sqf);};
			class UFOCropCircle {file = QPATHTOF(functions\ufo_crop_circle.sqf);};
			class UFOCropping {file = QPATHTOF(functions\ufo_cropping.sqf);};
			class UFOCrossLit {file = QPATHTOF(functions\ufo_cross_lit.sqf);};
			class UFOCross {file = QPATHTOF(functions\ufo_cross.sqf);};
			class UFOEncounter {file = QPATHTOF(functions\ufo_encounter.sqf);};
			class UFOHunt {file = QPATHTOF(functions\ufo_hunt.sqf);};
			class UFOLightCharge {file = QPATHTOF(functions\ufo_light_charge_sfx.sqf);};
			class UFOPuls {file = QPATHTOF(functions\ufo_puls.sqf);};
			class UFOSeeker {file = QPATHTOF(functions\ufo_seeker.sqf);};
			class UFOTravel {file = QPATHTOF(functions\ufo_travel_SFX.sqf);};
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
	class UFO_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "UFO_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_UFO";		
		displayName = CSTRING(ModuleUFO);
	};
	class Seeker_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Seeker_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Seeker";		
		displayName = CSTRING(ModuleSeeker);
	};
	class Cropcircle_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Cropcircle_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Cropcircle";		
		displayName = CSTRING(ModuleCropcircle);
	};
};
