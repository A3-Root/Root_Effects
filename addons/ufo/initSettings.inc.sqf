// CBA settings for the UFO component.

[
    QGVAR(enabledEncounter), "CHECKBOX",
    [LLSTRING(SettingEncounter), LLSTRING(SettingEncounterTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledSeeker), "CHECKBOX",
    [LLSTRING(SettingSeeker), LLSTRING(SettingSeekerTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;

[
    QGVAR(enabledCropCircle), "CHECKBOX",
    [LLSTRING(SettingCropCircle), LLSTRING(SettingCropCircleTooltip)],
    [ELSTRING(main,SettingCategory), LLSTRING(SettingCategoryName)],
    true, 1
] call CBA_fnc_addSetting;
