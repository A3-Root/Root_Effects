// Shared building blocks for 3DEN editor module definitions. Effect addons
// include this file from their CfgVehicles.hpp and expand the macros inside
// their module class bodies to keep attribute declarations uniform.

// Common properties for every Root's Effects 3DEN module. The module function
// runs once on the server at mission start and never inside the editor.
#define ROOT_MODULE_3DEN_COMMON \
    scope = 2; \
    category = "ROOT_EFFECTS"; \
    functionPriority = 1; \
    isGlobal = 0; \
    isTriggerActivated = 0; \
    isDisposable = 1; \
    is3DEN = 0; \
    icon = "\A3\Modules_F_Curator\Data\portraitEffectsZeus_ca.paa"

// Numeric attribute rendered as an edit box.
#define ROOT_ATTR_NUMBER(PROP,NAME,TIP,DEFVAL) \
    class PROP: Edit { \
        property = QUOTE(PROP); \
        displayName = NAME; \
        tooltip = TIP; \
        typeName = "NUMBER"; \
        defaultValue = QUOTE(DEFVAL); \
    }

// Free text attribute rendered as an edit box. DEFVAL must be a quoted SQF
// string expression, e.g. "'B_Plane_CAS_01_dynamicLoadout_F'".
#define ROOT_ATTR_STRING(PROP,NAME,TIP,DEFVAL) \
    class PROP: Edit { \
        property = QUOTE(PROP); \
        displayName = NAME; \
        tooltip = TIP; \
        typeName = "STRING"; \
        defaultValue = DEFVAL; \
    }

// Boolean attribute rendered as a checkbox.
#define ROOT_ATTR_BOOL(PROP,NAME,TIP,DEFVAL) \
    class PROP: Checkbox { \
        property = QUOTE(PROP); \
        displayName = NAME; \
        tooltip = TIP; \
        typeName = "BOOL"; \
        defaultValue = QUOTE(DEFVAL); \
    }
