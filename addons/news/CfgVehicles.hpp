#include "\z\root_effects\addons\main\module_attributes.hpp"

class CfgVehicles {
    class zen_modules_moduleBase;
    class ROOT_News_ModuleZeus: zen_modules_moduleBase {
        author = "Root";
        _generalMacro = "ROOT_News_ModuleZeus";
        category = "ROOT_EFFECTS";
        function = QFUNC(moduleNewsArticle);
        displayName = CSTRING(ModuleNews);
    };

    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Edit;
            class Checkbox;
            class ModuleDescription;
        };
        class ModuleDescription;
    };
    class ROOT_News_Module3DEN: Module_F {
        ROOT_MODULE_3DEN_COMMON;
        author = "Root";
        displayName = CSTRING(ModuleNews);
        function = QFUNC(moduleNewsArticle3DEN);
        class AttributeValues {};
        class Attributes: AttributesBase {
            ROOT_ATTR_STRING(ROOT_NEWS_TITLE,CSTRING(AttrTitle),CSTRING(AttrTitleTooltip),"'ARMA 3 - The Frontier of Armaverse'");
            ROOT_ATTR_STRING(ROOT_NEWS_EDITOR,CSTRING(AttrEditor),CSTRING(AttrEditorTooltip),"'Root'");
            ROOT_ATTR_STRING(ROOT_NEWS_DATE,CSTRING(AttrDate),CSTRING(AttrDateTooltip),"'2035/2/24 11:38'");
            ROOT_ATTR_STRING(ROOT_NEWS_TIMEZONE,CSTRING(AttrTimezone),CSTRING(AttrTimezoneTooltip),"'CET'");
            ROOT_ATTR_STRING(ROOT_NEWS_SUBHEAD,CSTRING(AttrSubhead),CSTRING(AttrSubheadTooltip),"''");
            ROOT_ATTR_STRING(ROOT_NEWS_IMAGE,CSTRING(AttrImage),CSTRING(AttrImageTooltip),"''");
            ROOT_ATTR_STRING(ROOT_NEWS_IMAGEDESC,CSTRING(AttrImageDesc),CSTRING(AttrImageDescTooltip),"''");
            ROOT_ATTR_STRING(ROOT_NEWS_BODY,CSTRING(AttrBody),CSTRING(AttrBodyTooltip),"''");
            ROOT_ATTR_STRING(ROOT_NEWS_BODYLOCKED,CSTRING(AttrBodyLocked),CSTRING(AttrBodyLockedTooltip),"''");
            ROOT_ATTR_STRING(ROOT_NEWS_EDITORIMG,CSTRING(AttrEditorImg),CSTRING(AttrEditorImgTooltip),"''");
            ROOT_ATTR_STRING(ROOT_NEWS_EDITORINFO,CSTRING(AttrEditorInfo),CSTRING(AttrEditorInfoTooltip),"''");
            ROOT_ATTR_BOOL(ROOT_NEWS_SHOWNOW,CSTRING(AttrShowNow),CSTRING(AttrShowNowTooltip),true);
            ROOT_ATTR_BOOL(ROOT_NEWS_DIARY,CSTRING(AttrDiary),CSTRING(AttrDiaryTooltip),false);
            ROOT_ATTR_STRING(ROOT_NEWS_DIARYTAB,CSTRING(AttrDiaryTab),CSTRING(AttrDiaryTabTooltip),"'AAN Reports'");
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(ModuleNewsDesc);
        };
    };
};
