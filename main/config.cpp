class CfgPatches {
	class Root_Effects {
		name = "Root's Effects";
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		requiredVersion = 0.1;
		units[] = {
			"Termination_Module"
		};
		requiredAddons[] = {
			"A3_Modules_F_Curator", 
			"cba_main", 
			"zen_custom_modules"
		};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootTerminationCategory
		{
			class Termination {file = "root_effects\main\functions\term_entities.sqf";};
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
	class Termination_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "Termination_Module";
		category = "ROOT_EFFECTS";
		function = "Root_fnc_Termination";
		displayName = "Terminate Effects";
	};
};

class CfgSounds {
	class far_05 {
		name = "far_05";
		sound[] = {"root_effects\main\sounds\05_far.ogg", "db+30", 1};
		titles[] = {};
	};
	class far_06 {
		name = "far_06";
		sound[] = {"root_effects\main\sounds\06_far.ogg", "db+30", 1};
		titles[] = {};
	};
	class far_08 {
		name = "far_08";
		sound[] = {"root_effects\main\sounds\08_far.ogg", "db+30", 1};
		titles[] = {};
	};
	class far_14 {
		name = "far_14";
		sound[] = {"root_effects\main\sounds\14_far.ogg", "db+30", 1};
		titles[] = {};
	};
	class far_21 {
		name = "far_21";
		sound[] = {"root_effects\main\sounds\21_far.ogg", "db+30", 1};
		titles[] = {};
	};
	class far_26 {
		name = "far_26";
		sound[] = {"root_effects\main\sounds\26_far.ogg", "db+30", 1};
		titles[] = {};
	};
	class alarama_aeriana_scurt {
		name = "alarama_aeriana_scurt";
		sound[] = {"root_effects\main\sounds\alarma_aeriana_scurt.ogg", "db+30", 1};
		titles[] = {};
	};
	class aterizat {
		name = "aterizat";
		sound[] = {"root_effects\main\sounds\aterizat.ogg", "db+30", 1};
		titles[] = {};
	};
	class bariera_1 {
		name = "bariera_1";
		sound[] = {"root_effects\main\sounds\bariera_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class bariera_2 {
		name = "bariera_2";
		sound[] = {"root_effects\main\sounds\bariera_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class bariera_3 {
		name = "bariera_3";
		sound[] = {"root_effects\main\sounds\bariera_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class bariera_4 {
		name = "bariera_4";
		sound[] = {"root_effects\main\sounds\bariera_4.ogg", "db+30", 1};
		titles[] = {};
	};
	class bariera_5 {
		name = "bariera_5";
		sound[] = {"root_effects\main\sounds\bariera_5.ogg", "db+30", 1};
		titles[] = {};
	};
	class broasca_3 {
		name = "broasca_3";
		sound[] = {"root_effects\main\sounds\broasca_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class charge_1 {
		name = "charge_1";
		sound[] = {"root_effects\main\sounds\charge_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class charge_2 {
		name = "charge_2";
		sound[] = {"root_effects\main\sounds\charge_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class charge_complete {
		name = "charge_complete";
		sound[] = {"root_effects\main\sounds\charge_complete.ogg", "db+30", 1};
		titles[] = {};
	};
	class crop_me {
		name = "crop_me";
		sound[] = {"root_effects\main\sounds\crop_me.ogg", "db+30", 1};
		titles[] = {};
	};
	class cutremur {
		name = "cutremur";
		sound[] = {"root_effects\main\sounds\cutremur.ogg", "db+30", 1};
		titles[] = {};
	};
	class earthquakes {
		name = "earthquakes";
		sound[] = {"root_effects\main\sounds\earthquakes.ogg", "db+30", 1};
		titles[] = {};
	};
	class earthquake_02 {
		name = "earthquake_02";
		sound[] = {"root_effects\main\sounds\earthquake_02.ogg", "db+30", 1};
		titles[] = {};
	};
	class earthquake_03 {
		name = "earthquake_03";
		sound[] = {"root_effects\main\sounds\earthquake_03.ogg", "db+30", 1};
		titles[] = {};
	};
	class eruptie_1 {
		name = "eruptie_1";
		sound[] = {"root_effects\main\sounds\eruptie_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class eruptie_1_eko {
		name = "eruptie_1_eko";
		sound[] = {"root_effects\main\sounds\eruptie_1_eko.ogg", "db+30", 1};
		titles[] = {};
	};
	class eruptie_2 {
		name = "eruptie_2";
		sound[] = {"root_effects\main\sounds\eruptie_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class eruptie_2_eko {
		name = "eruptie_2_eko";
		sound[] = {"root_effects\main\sounds\eruptie_2_eko.ogg", "db+30", 1};
		titles[] = {};
	};
	class eruptie_3 {
		name = "eruptie_3";
		sound[] = {"root_effects\main\sounds\eruptie_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class eruptie_3_eko {
		name = "eruptie_3_eko";
		sound[] = {"root_effects\main\sounds\eruptie_3_eko.ogg", "db+30", 1};
		titles[] = {};
	};
	class explosion_1 {
		name = "explosion_1";
		sound[] = {"root_effects\main\sounds\explosion_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class explosion_2 {
		name = "explosion_2";
		sound[] = {"root_effects\main\sounds\explosion_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class explosion_3 {
		name = "explosion_3";
		sound[] = {"root_effects\main\sounds\explosion_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class explosion_4 {
		name = "explosion_4";
		sound[] = {"root_effects\main\sounds\explosion_4.ogg", "db+30", 1};
		titles[] = {};
	};
	class expozie {
		name = "expozie";
		sound[] = {"root_effects\main\sounds\expozie.ogg", "db+30", 1};
		titles[] = {};
	};
	class fallstar_bariera_1 {
		name = "fallstar_bariera_1";
		sound[] = {"root_effects\main\sounds\fallstar_bariera_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class fallstar_bariera_2 {
		name = "fallstar_bariera_2";
		sound[] = {"root_effects\main\sounds\fallstar_bariera_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class fallstar_bariera_3 {
		name = "fallstar_bariera_3";
		sound[] = {"root_effects\main\sounds\fallstar_bariera_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class fallstar_bariera_4 {
		name = "fallstar_bariera_4";
		sound[] = {"root_effects\main\sounds\fallstar_bariera_4.ogg", "db+30", 1};
		titles[] = {};
	};
	class fallstar_bariera_5 {
		name = "fallstar_bariera_5";
		sound[] = {"root_effects\main\sounds\fallstar_bariera_5.ogg", "db+30", 1};
		titles[] = {};
	};
	class final_boom {
		name = "final_boom";
		sound[] = {"root_effects\main\sounds\final_boom.ogg", "db+30", 1};
		titles[] = {};
	};
	class flak_ground {
		name = "flak_ground";
		sound[] = {"root_effects\main\sounds\flak_ground.ogg", "db+30", 1};
		titles[] = {};
	};
	class ground_air {
		name = "ground_air";
		sound[] = {"root_effects\main\sounds\ground_air.ogg", "db+30", 1};
		titles[] = {};
	};
	class lansare {
		name = "lansare";
		sound[] = {"root_effects\main\sounds\lansare.ogg", "db+30", 1};
		titles[] = {};
	};
	class meteor_1 {
		name = "meteor_1";
		sound[] = {"root_effects\main\sounds\meteor_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class murmur_8 {
		name = "murmur_8";
		sound[] = {"root_effects\main\sounds\murmur_8.ogg", "db+30", 1};
		titles[] = {};
	};
	class roc_1 {
		name = "roc_1";
		sound[] = {"root_effects\main\sounds\roc_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class roc_2 {
		name = "roc_2";
		sound[] = {"root_effects\main\sounds\roc_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class roc_3 {
		name = "roc_3";
		sound[] = {"root_effects\main\sounds\roc_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class roc_4 {
		name = "roc_4";
		sound[] = {"root_effects\main\sounds\roc_4.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark1 {
		name = "spark1";
		sound[] = {"root_effects\main\sounds\spark1.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark11 {
		name = "spark11";
		sound[] = {"root_effects\main\sounds\spark11.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark2 {
		name = "spark2";
		sound[] = {"root_effects\main\sounds\spark2.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark22 {
		name = "spark22";
		sound[] = {"root_effects\main\sounds\spark22.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark3 {
		name = "spark3";
		sound[] = {"root_effects\main\sounds\spark3.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark4 {
		name = "spark4";
		sound[] = {"root_effects\main\sounds\spark4.ogg", "db+30", 1};
		titles[] = {};
	};
	class spark5 {
		name = "spark5";
		sound[] = {"root_effects\main\sounds\spark5.ogg", "db+30", 1};
		titles[] = {};
	};
	class static {
		name = "static";
		sound[] = {"root_effects\main\sounds\static.ogg", "db+30", 1};
		titles[] = {};
	};
	class test_1 {
		name = "test_1";
		sound[] = {"root_effects\main\sounds\test_1.ogg", "db+30", 1};
		titles[] = {};
	};
	class test_2 {
		name = "test_2";
		sound[] = {"root_effects\main\sounds\test_2.ogg", "db+30", 1};
		titles[] = {};
	};
	class test_3 {
		name = "test_3";
		sound[] = {"root_effects\main\sounds\test_3.ogg", "db+30", 1};
		titles[] = {};
	};
	class ufo_cross {
		name = "ufo_cross";
		sound[] = {"root_effects\main\sounds\ufo_cross.ogg", "db+30", 1};
		titles[] = {};
	};
};