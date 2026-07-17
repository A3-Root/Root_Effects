// CBA settings for the strikes component.

[
    QGVAR(enabledLaser), "CHECKBOX",
    [LLSTRING(SettingLaser), LLSTRING(SettingLaserTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledNapalm), "CHECKBOX",
    [LLSTRING(SettingNapalm), LLSTRING(SettingNapalmTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledCarpet), "CHECKBOX",
    [LLSTRING(SettingCarpet), LLSTRING(SettingCarpetTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledSingularity), "CHECKBOX",
    [LLSTRING(SettingSingularity), LLSTRING(SettingSingularityTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowDamage), "CHECKBOX",
    [LLSTRING(SettingAllowDamage), LLSTRING(SettingAllowDamageTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(maxBombs), "SLIDER",
    [LLSTRING(SettingMaxBombs), LLSTRING(SettingMaxBombsTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [1, 250, 35, 0], 1
] call CBA_fnc_addSetting;
