// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 



if (!hasInterface) exitWith {};

params ["_tracer_object_name","_colorred","_colorgreen","_colorblue","_activation_distance"];

private ["_xx","_yy","_zz","_dir","_obj_tras","_poc_mic","_nr_tracer","_li_tracer","_life_time_tras_lum","_range_trace","_ro","_ve","_bl","_life_time_tras"];

_life_time_tras = 3 + floor (random 10);


_ro = _colorred;
_ve = _colorgreen;
_bl = _colorblue;

_range_trace= 2;

while {al_tracer} do 
{
	if ((player distance _tracer_object_name) > _activation_distance) then {
		_nr_tras = 2 + floor (random 8);
		_xx 	= (floor (random 60)) * (selectRandom [1,-1]);
		_yy 	= (floor (random 60)) * (selectRandom [1,-1]);
		_zz		= 70 + floor(random 100);	

		while {_nr_tras > 0} do {
			_nr_tras = _nr_tras - 1;
			private ["_trasor"];
			_trasor = createVehicle ["Land_Battery_F", getPosATL _tracer_object_name, [], 0, "CAN_COLLIDE"];
			_trasor setVelocity [_xx + (random 1.5), _yy +(random 1.5), _zz + (random 1.5)];
			
			_li_tracer = "#lightpoint" createVehicleLocal (getPos _trasor);
			_li_tracer setLightAmbient[_ro, _ve, _bl];
			_li_tracer setLightColor[_ro, _ve, _bl];
			_li_tracer lightAttachObject [_trasor, [0,0,0]];
			_li_tracer setLightDayLight true;	
			_li_tracer setLightUseFlare true;
			_li_tracer setLightFlareSize 3;
			_li_tracer setLightFlareMaxDistance 5000;	
			_li_tracer setLightIntensity 5000;
			_li_tracer setLightAttenuation [_range_trace,0,100,0,_range_trace,_range_trace]; 			

			uiSleep 0.2 + (random 1);
			[_trasor, _life_time_tras, _li_tracer] spawn {
				_obj_tras			= _this select 0;
				_life_time_tras_del = _this select 1;
				_li_tracer			= _this select 2;
				uiSleep _life_time_tras_del;
				deleteVehicle _obj_tras;
				deleteVehicle _li_tracer;
			};			
		};
	};
	uiSleep 1 + (random 3);	
	if (!al_tracers_sunet_play) then {
		[_tracer_object_name, ["ground_air", 2000]] remoteExec ["say3d"];
		al_tracers_sunet_play = true;
		publicVariable "al_tracers_sunet_play";
	};
};

