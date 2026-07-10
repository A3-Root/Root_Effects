// CBA settings for the weather effects component.

[
    QGVAR(enabledLightning), "CHECKBOX",
    [LLSTRING(SettingLightning), LLSTRING(SettingLightningTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledAcidRain), "CHECKBOX",
    [LLSTRING(SettingAcidRain), LLSTRING(SettingAcidRainTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledMirage), "CHECKBOX",
    [LLSTRING(SettingMirage), LLSTRING(SettingMirageTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledWaterTint), "CHECKBOX",
    [LLSTRING(SettingWaterTint), LLSTRING(SettingWaterTintTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowDamage), "CHECKBOX",
    [LLSTRING(SettingAllowDamage), LLSTRING(SettingAllowDamageTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;
