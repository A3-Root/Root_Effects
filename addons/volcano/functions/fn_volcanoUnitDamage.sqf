#include "..\script_component.hpp"

// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

params ["_eruptionCenter"];

private _checkGear = {
			params ["_unit"];
			private _missingProtection = false;
			private _gearSlots = [headgear _unit, goggles _unit, uniform _unit, vest _unit, backpack _unit];
			{
				if (typeOf _x == "VirtualCurator_F") exitWith {_missingProtection = false};
				if !(_x in _gearSlots) exitWith {_missingProtection = true};
				} forEach volcanoProtectionGear;
			if (_missingProtection) exitWith {true};
			false
	};

while {volcanoActive} do {
	private _nearbyUnits = _eruptionCenter nearEntities [["Man","Air","Car","Motorcycle","Tank"],600];
	if (_nearbyUnits isNotEqualTo []) then {
		if (count volcanoProtectionGear > 0) then {
			{
				if (_x call _checkGear) then {
					if (_x isKindOf "Man") then {
						if (isNil "ace_medicalFncAddDamageToUnit") then {
							_x setDamage 1; 
						} else {
							private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
							{
								[_x, 1, _bodyPart, "ropeburn"] call ace_medicalFncAdddamagetoUnit;
							} forEach _bodyPart;
						};
                	} else { _x setDamage 1; }; 
				}; 
			} forEach _nearbyUnits; 
		};
		{ if (_x inArea [[9981.46,12077.1,74.964],280,220,0,false,200]) then {
			if (_x isKindOf "Man") then {
				private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
				if (isNil "ace_medicalFncAddDamageToUnit") then {
					_x setDamage 1;
				} else {
					{
						[_x, 1, _bodyPart, "ropeburn"] call ace_medicalFncAdddamagetoUnit;
					} forEach _bodyPart;
				};
            } else { _x setDamage 1; };}
		} forEach _nearbyUnits;
	};
	uiSleep 2;
};
