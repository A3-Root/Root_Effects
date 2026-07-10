// CBA settings for the briefing component.

[
    QGVAR(enabledMap), "CHECKBOX",
    [LLSTRING(SettingMap), LLSTRING(SettingMapTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledTable), "CHECKBOX",
    [LLSTRING(SettingTable), LLSTRING(SettingTableTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(mapUpdateInterval), "SLIDER",
    [LLSTRING(SettingMapInterval), LLSTRING(SettingMapIntervalTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [0.25, 2, 0.5, 2], 0
] call CBA_fnc_addSetting;

[
    QGVAR(maxTableObjects), "SLIDER",
    [LLSTRING(SettingMaxTableObjects), LLSTRING(SettingMaxTableObjectsTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [100, 2000, 500, 0], 0
] call CBA_fnc_addSetting;
