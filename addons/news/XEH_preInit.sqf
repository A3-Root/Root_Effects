#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

// Locally stored articles, keyed by article id, so diary entries can reopen
// them without embedding the whole article text in the diary record.
GVAR(articles) = createHashMap;

// Make this effect known to the shared registry on every machine. Articles
// are one-shot broadcasts, so they never appear in the termination dialog;
// the registration only feeds the enable setting.
[
    "news",
    LLSTRING(ModuleNews),
    QGVAR(enabled)
] call EFUNC(main,registerEffect);

ADDON = true;
