// CBA settings for the ambient effects component.

[
    QGVAR(enabledFireflies), "CHECKBOX",
    [LLSTRING(SettingFireflies), LLSTRING(SettingFirefliesTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledAurora), "CHECKBOX",
    [LLSTRING(SettingAurora), LLSTRING(SettingAuroraTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledRupture), "CHECKBOX",
    [LLSTRING(SettingRupture), LLSTRING(SettingRuptureTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledSparks), "CHECKBOX",
    [LLSTRING(SettingSparks), LLSTRING(SettingSparksTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledBirdSwarm), "CHECKBOX",
    [LLSTRING(SettingBirdSwarm), LLSTRING(SettingBirdSwarmTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(maxSwarmBirds), "SLIDER",
    [LLSTRING(SettingMaxBirds), LLSTRING(SettingMaxBirdsTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [5, 60, 25, 0], 1
] call CBA_fnc_addSetting;
