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
		tag = "Root";
		class RootUFOCategory
		{
			file = QPATHTOF(functions);
			class moduleUfoEncounter {};
			class moduleUfoSeeker {};
			class moduleUfoCropCircle {};
			class ufoChargingEffects {};
			class createUfoCropCircle {};
			class animateUfoCropCircle {};
			class ufoCrossLighting {};
			class ufoCrossFlyby {};
			class ufoEncounterServer {};
			class updateUfoTarget {};
			class ufoLightChargeEffects {};
			class ufoPulseEffects {};
			class ufoSeekerServer {};
			class ufoTravelEffects {};
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
		function = "Root_fnc_moduleUfoEncounter";		
		displayName = CSTRING(ModuleUFO);
	};
	class Seeker_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Seeker_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleUfoSeeker";		
		displayName = CSTRING(ModuleSeeker);
	};
	class Cropcircle_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Cropcircle_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_moduleUfoCropCircle";		
		displayName = CSTRING(ModuleCropcircle);
	};
};
