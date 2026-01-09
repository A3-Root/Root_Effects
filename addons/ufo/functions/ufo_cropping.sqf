// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT

if (!hasInterface) exitWith {};

private _orbit = {
	params ["_ufo","_orb_obj","_orbit_speed","_radius","_crop"];
	private _ung = 0;
	private _placeit=0;
	"Crater" createVehicleLocal getPos _ufo;
	while {_ung<360} do {
		private _poz_rel=_ufo getRelPos [_radius,_ung];
		_orb_obj setPos [_poz_rel#0,_poz_rel#1,2];
		drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.3,[0,0,0],[0,0,0],0,9.999,7,0,[1,10],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orb_obj];
		if ((_crop)&&(_placeit==0)) then {"Land_ShellCrater_02_decal_F" createVehicleLocal _poz_rel; if (_radius>=50) then {_placeit=4} else {_placeit=12}};
		_placeit=_placeit-1;
		_ung=_ung+1;
		uiSleep _orbit_speed;
	};
	playSound3D [lans,objNull,false,[getPos _orb_obj # 0,getPos _orb_obj # 1,100],10,1,3000];
	for "_i" from 1 to 10 do { 
		uiSleep 0.2;
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orb_obj];
	};
	drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orb_obj];
	deleteVehicle _orb_obj;
};

private _spiral = {
	params ["_ufo","_orb_obj","_orbit_speed","_radius","_crop"];
	private _ung = 0;
	private _placeit=0;
	"Crater" createVehicleLocal getPos _ufo;
	while {_ung<1260} do {
		private _poz_rel=_ufo getRelPos [_radius,_ung];
		_orb_obj setPos [_poz_rel#0,_poz_rel#1,2];
		drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.3,[0,0,0],[0,0,0],0,9.999,7,0,[1,10],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orb_obj];
		if ((_crop)&&(_placeit==0)) then {"Land_ShellCrater_02_decal_F" createVehicleLocal _poz_rel; _placeit=2};
		_placeit=_placeit-1;
		_radius=_radius+0.1;
		_ung=_ung+1;
		uiSleep _orbit_speed;
	};
	playSound3D [lans,objNull,false,[getPos _orb_obj # 0,getPos _orb_obj # 1,100],10,1,3000];
	for "_i" from 1 to 10 do { 
		uiSleep 0.2;
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orb_obj];
	};
	drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orb_obj];
	deleteVehicle _orb_obj;
};

private _floare = {
	private ["_ung","_orb_reper", "_ang"];
	params ["_ufo","_orb_obj","_orbit_speed","_radius","_crop"];
	_ang = 0;
	"Crater" createVehicleLocal getPos _ufo;
	_orb_reper = "Sign_Sphere100cm_F" createVehicleLocal [0,0,0];
	_orb_reper setObjectTextureGlobal [0,"#(argb,8,8,3)color(1,1,1,0,ca)"];
	_orb_reper setObjectMaterialGlobal [0, "a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"];
	while {_ang<360} do {
		_ung = 360;
		private _poz_rel = _ufo getRelPos [_radius,_ang];
		_orb_reper setPos _poz_rel;
		private _placeit = 0;
		while {_ung > 0} do {
			private _poz_rel_1 = _orb_reper getRelPos [15,_ung];
			_orb_obj setPos [_poz_rel_1#0,_poz_rel_1#1,2];
			drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,0.2,[0,0,0],[0,0,0],0,9.999,7,0,[1,5],[[0.443,0.706,0.81,0.2],[0.443,0.706,0.81,0]],[1],0,0,"","",_orb_obj];
			if ((_crop)&&(_placeit==0)) then {"Land_ShellCrater_02_decal_F" createVehicleLocal getPos _orb_obj; _placeit=18};
			_placeit=_placeit-1;
			_ung=_ung-1;
			if ((_ung<10)||(_ung>349)) then {drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.3,1,[1,1,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orb_obj]};
			uiSleep _orbit_speed;
		};
		_ang=_ang+30;
	};
	playSound3D [lans,objNull,false,[getPos _orb_obj # 0,getPos _orb_obj # 1,100],10,1,3000];
	for "_i" from 1 to 10 do { 
		uiSleep 0.2;
		drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orb_obj];
	};
	drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,0],[0,0,200],0,9,7,0,[10,1],[[1,1,1,1],[0.9,.9,1,1]],[1],0,0,"","",_orb_obj];
	deleteVehicle _orb_obj;
	deleteVehicle _orb_reper;
};

params ["_ufo","_radius","_typ_crop"];
enableCamShake true;
if (isNil "sunet_ini") then {
	playSound3D ["aterizat", objNull, false, [getPos _ufo select 0, getPos _ufo select 1, 200], 10, 1, 0];
	[] spawn {
		uiSleep 3.9;
		addCamShake [2,10,30];
		playSound "cutremur";
	};
	sunet_ini = true;
};
uiSleep 1.3;
private _orb_obj = "#lightpoint" createVehicleLocal [0,0,0];
_orb_obj setLightDayLight true;_orb_obj setLightUseFlare true;
_orb_obj setLightFlareSize 5; _orb_obj setLightFlareMaxDistance 5000;	
_orb_obj setLightAmbient[0.5,0.5,1]; _orb_obj setLightColor[0.443,0.706,0.9];
_orb_obj setLightAttenuation [0,0,0,0,0,4000]; 
_orb_obj setLightBrightness 5;

drop [["\A3\data_f\kouleSvetlo",1,0,1],"","Billboard",1,2.5,[0,0,500],[0,0,-200],0,9,7,0,[1,10],[[0,0,1,1],[0.9,.9,1,1]],[1],0,0,"","",_ufo];
uiSleep 2;
for "_i" from 1 to 3 do { 
	uiSleep 0.1;
	drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",.5,1,[0,0,0],[0,0,0],0,9,7,0,[1,10,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_orb_obj];
};
uiSleep 0.3;
private _blast_wave = "#particlesource" createVehicleLocal getPos _ufo;
_blast_wave setParticleCircle [5,[0,0,0]];
_blast_wave setParticleRandom [0.1,[3,3,1],[100,100,0],0,2,[0,0,0,0.5],1,0];
_blast_wave setParticleParams [["\A3\data_f\cl_basic",1,0,1],"","Billboard",1,3,[1,1,2],[0,0,-5],0,20,1,1,[5,10],[[0,0,0,0.3],[0.1,0.1,0.1,0]],[1],1,0,"","",_ufo];
_blast_wave setDropInterval 0.002;
[_blast_wave] spawn {private _de_sters = _this select 0; uiSleep 0.2; deleteVehicle _de_sters};
switch (_typ_crop) do {
    case "circle": {[_ufo,_orb_obj,0.01,_radius,true] spawn _orbit};
    case "spiral": {[_ufo,_orb_obj,0.01,_radius,true] spawn _spiral};
    case "flower": {[_ufo,_orb_obj,0.01,_radius,true] spawn _floare};
};
while {alive _orb_obj} do {
	_orb_obj say3D ["crop_me", 2000];
	uiSleep 17;
};
