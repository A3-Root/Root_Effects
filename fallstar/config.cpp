class CfgPatches
{
	class Root_Fallstar_Effect
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
			class Fallstar {file = "root_effects\fallstar\functions\init_fallstar.sqf";};
			class FallstarFallingIni {file = "root_effects\fallstar\functions\fallstar_fallingstar_ini.sqf";};
			class FallstarFalling {file = "root_effects\fallstar\functions\fallstar_fallingstar.sqf";};
			class FallstarHunt {file = "root_effects\fallstar\functions\fallstar_hunt.sqf";};
			class FallstarLumina {file = "root_effects\fallstar\functions\fallstar_lumina.sqf";};
			class FallstarMeteorEnd {file = "root_effects\fallstar\functions\fallstar_meteor_end_blast.sqf";};
			class FallstarMeteorBlast {file = "root_effects\fallstar\functions\fallstar_meteor_ini_blast.sqf";};
			class FallstarMeteorIni {file = "root_effects\fallstar\functions\fallstar_meteor_ini.sqf";};
			class FallstarMeteor {file = "root_effects\fallstar\functions\fallstar_meteor.sqf";};
			class FallstarMeteorEffect {file = "root_effects\fallstar\functions\fallstar_meteoreffect.sqf";};
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

class CfgVehicles
{
	class zen_modules_moduleBase;
	class Fallstar_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Fallstar_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Fallstar";
		displayName = "Meteors/Comets";
	};
};
