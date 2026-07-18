// CBA settings for the drone feed component.

[
    QGVAR(enabled), "CHECKBOX",
    [LLSTRING(SettingEnabled), LLSTRING(SettingEnabledTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(maxFeeds), "SLIDER",
    [LLSTRING(SettingMaxFeeds), LLSTRING(SettingMaxFeedsTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [1, 20, 5, 0], 1
] call CBA_fnc_addSetting;

[
    QGVAR(textureResolution), "LIST",
    [LLSTRING(SettingResolution), LLSTRING(SettingResolutionTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [[512, 1024, 2048], ["512", "1024", "2048"], 1], 1
] call CBA_fnc_addSetting;

[
    QGVAR(autoCycleInterval), "SLIDER",
    [LLSTRING(SettingCycleInterval), LLSTRING(SettingCycleIntervalTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [2, 60, 10, 0], 0
] call CBA_fnc_addSetting;
