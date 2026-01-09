// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

params ["_poz"];

private _check_gear ={
			params ["_unit"];
			private _ck_ret=false;
			private _slot_check = [headgear _unit, goggles _unit, uniform _unit, vest _unit, backpack _unit];
			{
				if (typeOf _x == "VirtualCurator_F") exitWith {_ck_ret=false};
				if !(_x in _slot_check) exitWith {_ck_ret=true};
				} forEach protect_volcano;
			if (_ck_ret) exitWith {true};
			false
	};

while {volcano} do {
	private _unit_dead = _poz nearEntities [["Man","Air","Car","Motorcycle","Tank"],600];
	if (_unit_dead isNotEqualTo []) then {
		if (count protect_volcano > 0) then {
			{
				if (_x call _check_gear) then {
					if (_x isKindOf "Man") then {
						if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
							private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
							{
								[_x, 1, _bodyPart, "ropeburn"] call ace_medical_fnc_adddamagetoUnit;
							} forEach _bodyPart;
						} else { _x setDamage 1; };
                	} else { _x setDamage 1; }; 
				}; 
			} forEach _unit_dead; 
		};
		{ if (_x inArea [[9981.46,12077.1,74.964],280,220,0,false,200]) then {
			if (_x isKindOf "Man") then {
				private _bodyPart = ["Head", "RightLeg", "LeftArm", "Body", "LeftLeg", "RightArm"];
				if (!(isNil "ace_medical_fnc_addDamageToUnit")) then {
					{
						[_x, 1, _bodyPart, "ropeburn"] call ace_medical_fnc_adddamagetoUnit;
					} forEach _bodyPart;
				} else { _x setDamage 1; };
            } else { _x setDamage 1; };}
		} forEach _unit_dead;
	};
	uiSleep 2;
};

