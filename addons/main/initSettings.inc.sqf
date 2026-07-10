// CBA settings shared by every Root's Effects module.

[
    QGVAR(enabled), "CHECKBOX",
    [LLSTRING(SettingEnabled), LLSTRING(SettingEnabledTooltip)],
    [LLSTRING(SettingCategory), LLSTRING(SettingCategoryGeneral)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(debugLogging), "CHECKBOX",
    [LLSTRING(SettingDebug), LLSTRING(SettingDebugTooltip)],
    [LLSTRING(SettingCategory), LLSTRING(SettingCategoryGeneral)],
    false, 1
] call CBA_fnc_addSetting;

[
    QGVAR(damageAllowed), "CHECKBOX",
    [LLSTRING(SettingDamage), LLSTRING(SettingDamageTooltip)],
    [LLSTRING(SettingCategory), LLSTRING(SettingCategoryGeneral)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(maxViewDistance), "SLIDER",
    [LLSTRING(SettingViewDistance), LLSTRING(SettingViewDistanceTooltip)],
    [LLSTRING(SettingCategory), LLSTRING(SettingCategoryGeneral)],
    [500, 10000, 3000, 0], 1
] call CBA_fnc_addSetting;

[
    QGVAR(particleBudget), "SLIDER",
    [LLSTRING(SettingParticleBudget), LLSTRING(SettingParticleBudgetTooltip)],
    [LLSTRING(SettingCategory), LLSTRING(SettingCategoryGeneral)],
    [0.1, 1, 1, 2], 0
] call CBA_fnc_addSetting;
