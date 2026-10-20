// CBA settings for the EMP component.

[
    QGVAR(enabled), "CHECKBOX",
    [LLSTRING(SettingEnabled), LLSTRING(SettingEnabledTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowVehicleKill), "CHECKBOX",
    [LLSTRING(SettingVehicleKill), LLSTRING(SettingVehicleKillTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowDestroy), "CHECKBOX",
    [LLSTRING(SettingAllowDestroy), LLSTRING(SettingAllowDestroyTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(acreJam), "CHECKBOX",
    [LLSTRING(SettingAcreJam), LLSTRING(SettingAcreJamTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowFlicker), "CHECKBOX",
    [LLSTRING(SettingAllowFlicker), LLSTRING(SettingAllowFlickerTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(allowImplodeBlast), "CHECKBOX",
    [LLSTRING(SettingAllowImplodeBlast), LLSTRING(SettingAllowImplodeBlastTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(domeDepth), "LIST",
    [LLSTRING(SettingDomeDepth), LLSTRING(SettingDomeDepthTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [[0, 1, 2], [LLSTRING(DepthShallow), LLSTRING(DepthDeep), LLSTRING(DepthFull)], 0], 1
] call CBA_fnc_addSetting;

[
    QGVAR(domeQuality), "LIST",
    [LLSTRING(SettingDomeQuality), LLSTRING(SettingDomeQualityTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    [[0, 1, 2], [LLSTRING(QualityOff), LLSTRING(QualityLow), LLSTRING(QualityHigh)], 2]
] call CBA_fnc_addSetting;

[
    QGVAR(showCountdown3D), "CHECKBOX",
    [LLSTRING(SettingCountdown3D), LLSTRING(SettingCountdown3DTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true
] call CBA_fnc_addSetting;
