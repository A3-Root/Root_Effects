// CBA settings for the battle effects component.

[
    QGVAR(enabledAAA), "CHECKBOX",
    [LLSTRING(SettingAAA), LLSTRING(SettingAAATooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledArtillery), "CHECKBOX",
    [LLSTRING(SettingArtillery), LLSTRING(SettingArtilleryTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledMissiles), "CHECKBOX",
    [LLSTRING(SettingMissiles), LLSTRING(SettingMissilesTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledSearchlight), "CHECKBOX",
    [LLSTRING(SettingSearchlight), LLSTRING(SettingSearchlightTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledTracers), "CHECKBOX",
    [LLSTRING(SettingTracers), LLSTRING(SettingTracersTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowDamage), "CHECKBOX",
    [LLSTRING(SettingAllowDamage), LLSTRING(SettingAllowDamageTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;
