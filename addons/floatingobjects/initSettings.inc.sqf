// CBA settings for the floating objects component.

[
    QGVAR(enabled), "CHECKBOX",
    [LLSTRING(SettingEnabled), LLSTRING(SettingEnabledTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;
