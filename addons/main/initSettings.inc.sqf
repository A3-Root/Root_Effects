// CBA settings shared by every Root's Effects module.

[
    QGVAR(enabled), "CHECKBOX",
    [LLSTRING(SettingEnabled), LLSTRING(SettingEnabledTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryGeneral)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(debugLogging), "CHECKBOX",
    [LLSTRING(SettingDebug), LLSTRING(SettingDebugTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryGeneral)],
    false, 1
] call CBA_fnc_addSetting;

[
    QGVAR(damageAllowed), "CHECKBOX",
    [LLSTRING(SettingDamage), LLSTRING(SettingDamageTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryGeneral)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(maxViewDistance), "SLIDER",
    [LLSTRING(SettingViewDistance), LLSTRING(SettingViewDistanceTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryGeneral)],
    [500, 10000, 3000, 0], 1
] call CBA_fnc_addSetting;

[
    QGVAR(particleBudget), "SLIDER",
    [LLSTRING(SettingParticleBudget), LLSTRING(SettingParticleBudgetTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryGeneral)],
    [0.1, 1, 1, 2], 0
] call CBA_fnc_addSetting;
