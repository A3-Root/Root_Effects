class CfgPatches
{
	class Root_News_Effect
	{
		name = "Root's Effects";
		author = "Root";
		authors[] = {
			"Root",
			"Aliascartoons"
		};
		url = "https://github.com/A3-Root/Root_Effects";
		requiredVersion = 0.1;
		addonRootClass = "Root_Effects";
		requiredAddons[] = {"A3_Modules_F_Curator","cba_main","Root_Effects", "zen_custom_modules"};
		units[] = {"News_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class Root
	{
		class RootNewsCategory
		{
			class News {file = "root_effects\news\functions\init_news.sqf";};
			class NewsDiary {file = "root_effects\news\functions\news_diary.sqf";};
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
	class News_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "News_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "Root_fnc_News";
		displayName = "AAN News Article";
	};
};