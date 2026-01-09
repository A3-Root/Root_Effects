// CREATED BY ROOT
// Only run on server
if (!isServer) exitWith {};
// If ZEN is not loaded, do not start script
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith
{
    diag_log "******CBA and/or ZEN not detected. They are required for this mod.";
};



DCON_boomSounds = [ "A3\Sounds_F\arsenal\explosives\shells\30mm40mm_shell_explosion_01.wss", "A3\Sounds_F\arsenal\explosives\shells\Artillery_tank_shell_155mm_explosion_02.wss", "A3\Sounds_F\arsenal\explosives\shells\tank_shell_explosion_02.wss", "A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_04.wss", "A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_05.wss", "A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_06.wss", "A3\Sounds_F\arsenal\explosives\shells\Artillery_shell_explosion_07.wss", "A3\Sounds_F\arsenal\weapons\Launchers\RPG32\RPG32_Hit.wss" ];

DCON_launchSounds = [ "A3\Sounds_F\arsenal\weapons_static\Missile_Launcher\Titan.wss", "A3\Sounds_F\arsenal\weapons\Launchers\Titan\Titan.wss", "A3\Sounds_F\arsenal\weapons\Launchers\RPG32\rpg32.wss", "A3\Sounds_F\arsenal\weapons\Launchers\NLAW\nlaw.wss" ];

private _fireworkSounds = {
    private _boomSound = selectRandom DCON_boomSounds;
    private _launchSound = selectRandom DCON_launchSounds;
    playSound3D [_launchSound, _this select 0];
    uiSleep 2.3;
    playSound3D [_boomSound, _this select 0];
};

private _fireworkVisuals = {
    private _firing_position = _this select 0;
    private _firing_dir = _this select 1;
    private _rocket = _this select 2;
    private _color = _this select 3;
    private _explosion_power = 100;
    private _glitter_count = 20;
    private _initial_velocity = _firing_dir vectorMultiply 300;
    private _explosion_fragments_array = [];
    private _explosion_subfragments_array = [];
    private _randomLaunch = (random 4.5) - 2.3;
    private _randomsleep = (random 0.5) - 0.25;
    private _randomsleepLong = (random 8) - 4;
    for [{
        private _i=0
    }, {
        _i < _glitter_count
    }, {
        _i=_i+1
    }] do {
    private _rand_expl_power1 = ((random _explosion_power)*2) - _explosion_power;
    private _rand_expl_power2 = ((random _explosion_power)*2) - _explosion_power;
    private _rand_expl_power3 = ((random _explosion_power)*2) - _explosion_power;
    _explosion_fragments_array = _explosion_fragments_array + [[(_rand_expl_power1) -_rand_expl_power1/2, (_rand_expl_power2) -_rand_expl_power2/2, (_rand_expl_power3) -_rand_expl_power3/2]];
    if (_i < _glitter_count/3) then {
        private _rand_subexpl_power1 = ((random _explosion_power)/2) - _explosion_power/2;
        private _rand_subexpl_power2 = ((random _explosion_power)/2) - _explosion_power/2;
        private _rand_subexpl_power3 = ((random _explosion_power)/2) - _explosion_power/2;
        _explosion_subfragments_array = _explosion_subfragments_array + [[(_rand_subexpl_power1/4) -_rand_subexpl_power1/8, (_rand_subexpl_power2/4) -_rand_subexpl_power2/8, (_rand_subexpl_power3/4) -_rand_subexpl_power3/8]];
    };
	};
	private _light1 = "#lightpoint" createVehicle [0, 0, 0];
	[_light1, 0.1] remoteExec ['setLightBrightness', [0, -2] select isDedicated];
	[_light1, [1, 0.3, 0]] remoteExec ['setLightColor', [0, -2] select isDedicated];
	[_light1, true] remoteExec ['setLightUseFlare', [0, -2] select isDedicated];
	[_light1, 1000] remoteExec ['setLightFlareMaxDistance', [0, -2] select isDedicated];
	[_light1, 5] remoteExec ['setLightFlaresize', [0, -2] select isDedicated];
	private _light2 = "#lightpoint" createVehicle [0, 0, 0];
	[_light2, 3] remoteExec ['setLightBrightness', [0, -2] select isDedicated];
	[_light2, [1, 0.8, 0]] remoteExec ['setLightColor', [0, -2] select isDedicated];
	[_light2, true] remoteExec ['setLightUseFlare', [0, -2] select isDedicated];
	[_light2, 1000] remoteExec ['setLightFlareMaxDistance', [0, -2] select isDedicated];
	[_light2, 8] remoteExec ['setLightFlaresize', [0, -2] select isDedicated];
	uiSleep 0.01;
	[_light1, [_rocket, [0, 0, 0]]] remoteExec ['lightAttachObject', [0, -2] select isDedicated];
	[_light2, [_rocket, [0, 0, 0]]] remoteExec ['lightAttachObject', [0, -2] select isDedicated];
	uiSleep 2.3;
	deleteVehicle _light1;
	deleteVehicle _light2;
	for [{
		private _i=0
	}, {
		_i < count _explosion_fragments_array
	}, {
		_i=_i+1
	}] do {
	[_rocket, _explosion_fragments_array, _color, _i] spawn {
		private _rocket = _this select 0;
		private _fragments = _this select 1;
		private _color2 = _this select 2;
		private _selector = _this select 3;
		_rocket = "CMflare_Chaff_ammo" createVehicle (getPos _rocket);
		private _smoke = "SmokeLauncherammo" createVehicle (getPos _rocket);
		_rocket setVelocity (_fragments select _selector);
		private _light2 = "#lightpoint" createVehicle [0, 0, 0];
		[_light2, 3] remoteExec ['setLightBrightness'];
		[_light2, _color2] remoteExec ['setLightAmbient'];
		[_light2, _color2] remoteExec ['setLightColor'];
		[_light2, [_rocket, [0, 0, 0]]] remoteExec ['lightAttachObject'];
		[_light2, true] remoteExec ['setLightUseFlare'];
		[_light2, 1000] remoteExec ['setLightFlareMaxDistance'];
		[_light2, 10] remoteExec ['setLightFlaresize'];
		uiSleep 5;
		deleteVehicle _light2;
	};
	};
	uiSleep 1;
	uiSleep 7;
	deleteVehicle _rocket;
};


M9SD_fnc_spawnfireworks = {
    private _pos = [14650.3,16759,0];
    private _fireworkcount = 1;
    private _colorArray = [ [0.42, 0.81, 0.1], [0.8, 0.1, 0.35], [0.2, 0.73, 0.85], [1, 1, 1], [0.1, 0.81, 0.1] ];
    for "_i" from 1 to _fireworkcount do {
        private _velocity = [random 1024, random 1024, random [1000, 2500, 5000]];
        private _color = selectRandom _colorArray;
        private _firework = "CMflare_Chaff_ammo" createVehicle _pos;
        _firework setDir (random 359);
        _firework setVelocity _velocity;
        private _firingdir = [selectRandom [0, 1], selectRandom [0, 1], selectRandom [0, 1]];
        [_pos, _firingdir, _firework, _color] spawn DCON_fnc_fireworkVisuals;
        [_firework] spawn DCON_fnc_fireworkSounds;
        uiSleep 1.5;
    };
};


[] spawn M9SD_fnc_spawnfireworks;
