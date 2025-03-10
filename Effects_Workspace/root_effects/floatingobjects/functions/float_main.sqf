// ORIGINALLY CREATED BY ALIAS
// MODIFIED BY ROOT 

if (!isServer) exitWith {};

params ["_object_name","_slide_move","_bounce_move","_rot_move","_roll_vel","_orbit_move","_dist_dependent", "_elevation", "_allow_damage", "_allow_simulation"];

if (!isNil{_object_name getVariable "activ"}) exitWith {};
_object_name setVariable ["activ", true, true];

// _nclass = typeOf _object_name;
// _nclass = _object_name;
_poz_obj= getposatl _object_name;
_alt_obj= _elevation;
// deleteVehicle _object_name;

[_object_name,_slide_move,_bounce_move,_rot_move,_roll_vel,_orbit_move,_dist_dependent,_poz_obj,_alt_obj,_allow_damage,_allow_simulation] remoteExec ["Root_fnc_FloatingObj", [0, -2] select isDedicated, true];