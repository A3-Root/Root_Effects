class CfgPatches
{
	class Root_UFO_Effects
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
			class UFO {file = "root_effects\ufo\functions\init_ufo.sqf";};
			class Seeker {file = "root_effects\ufo\functions\init_seeker.sqf";};
			class Cropcircle {file = "root_effects\ufo\functions\init_cropcircle.sqf";};
			class UFOCharging {file = "root_effects\ufo\functions\ufo_charging_SFX.sqf";};
			class UFOCropCircle {file = "root_effects\ufo\functions\ufo_crop_circle.sqf";};
			class UFOCropping {file = "root_effects\ufo\functions\ufo_cropping.sqf";};
			class UFOCrossLit {file = "root_effects\ufo\functions\ufo_cross_lit.sqf";};
			class UFOCross {file = "root_effects\ufo\functions\ufo_cross.sqf";};
			class UFOEncounter {file = "root_effects\ufo\functions\ufo_encounter.sqf";};
			class UFOHunt {file = "root_effects\ufo\functions\ufo_hunt.sqf";};
			class UFOLightCharge {file = "root_effects\ufo\functions\ufo_light_charge_sfx.sqf";};
			class UFOPuls {file = "root_effects\ufo\functions\ufo_puls.sqf";};
			class UFOSeeker {file = "root_effects\ufo\functions\ufo_seeker.sqf";};
			class UFOTravel {file = "root_effects\ufo\functions\ufo_travel_SFX.sqf";};
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
	class UFO_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "UFO_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_UFO";		
		displayName = "UFO";
	};
	class Seeker_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Seeker_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Seeker";		
		displayName = "UFO Seeker";
	};
	class Cropcircle_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Cropcircle_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Cropcircle";		
		displayName = "UFO Cropcircle";
	};
};