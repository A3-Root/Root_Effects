#include "script_component.hpp"

class CfgPatches
{
	class root_effects_news
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
		units[] = {"News_Module"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class root_effects_news
	{
		tag = "root_effects_news";
		class RootNewsCategory
		{
			file = QPATHTOF(functions);
			class moduleNewsArticle {};
			class broadcastNewsArticle {};
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
	class News_Module: zen_modules_moduleBase
	{
		author = "Root";
		_generalMacro = "News_Module";
		curatorCanAttach = 1;
		category = "ROOT_EFFECTS";
		function = "root_effects_news_fnc_moduleNewsArticle";
		displayName = CSTRING(ModuleNews);
	};
};
