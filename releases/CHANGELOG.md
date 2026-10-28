# Changelog for Root's Effects

## Version: 4.0.0.2
### Changed
- Drone feed no longer binds or terminates the render camera while Zeus is open; feed start and stop wait until Zeus closes.

## Version: 4.0.0.1
### Added
- Build-up time for Aurora, Spacetime Rupture, Lightning Storm and Acid Rain: instant, X seconds or default.
- Snap To Full option in Modify Sky Effect.
- EMP Field (replaces EMP Pulse): field on an object or position with countdown, shockwave, force field dome and Zeus-editable map marker.
- EMP Field knockout: vehicle, aircraft and UAV modes (disable / destroy, crash), lamps (off / broken), gear (suppress / fry); engine wrecked until recovery so it cannot be restarted inside.
- EMP Field gear suppression: night vision, weapon lights and lasers, binoculars, info panels, UAV terminal, cTab, ACE devices and ACRE radios; electronic devices taken and given back on recovery.
- EMP Field timing: effect delay after the wave, grace time for units entering later, recovery on leaving with Recovery Delay (s outside before recovery).
- EMP Field approach warning: HUD blinks out near the field, ranges for ground, helicopter and plane.
- EMP Field dome: frosted glass, same from inside and outside, reaches into the ground; colour, opacity, shimmer, lightning, heat haze and depth options.
- EMP Field light flicker: weapon lights, vehicle lights and lamps inside flicker, lit / dark time ranges.
- EMP Field shutdown: hold action or ACE interaction on the object (invisible wall for fields on the ground), required item, shutdown time and distance; Zeus terminate; ends when the object is destroyed.
- EMP Field shutdown effect: Fade, or Implode (wall runs back in at Shutdown Shockwave Speed, marker shrinks, units recover as it passes) with optional blast (40 mm grenade, 82 mm mortar round).
- EMP Field effects: charge glow, lightning bolts on the dome wall and shockwave front, sparks and crackle; breaking lamps, destroyed vehicles and fried gear burst into sparks; arcs, sparks, crackle and heat haze around players inside.
- EMP Field Zeus module attaches to the object it is placed on; 3DEN module is trigger activated and syncs to an object.
- Modify EMP Field module (Zeus and 3DEN): change settings live or shut down.
- EMP public API: create, disable, modify, isInside; every setting as a key (e.g. `implodeSpeed`, `restoreDelay`).
- EMP CBA settings: Allow Destroy And Fry, Jam ACRE Radios, Allow Light Flicker, Allow Implosion Blast, Dome Depth, Dome Quality, Show Countdown Timer, Shutdown Shockwave Speed, Recovery Delay.

### Changed
- EMP Pulse module replaced by EMP Field.
- Late joiners see aurora and rupture bands at full strength.
- Shared post process helper picks a free priority.
- Drone feed: no RPT error spam in the turret aim lookup; monitor no longer removes feeds while iterating.
- Sounds from client side effects play once (EMP, fireworks, cryo blast, meteor, laser, singularity, UFO, lightning).
- Briefing map take / release control actions work.
- Comet flight direction corrected.
- Napalm damage area no longer rotated.
- Meteor knock back works on remote units.
- Singularity fling hook no longer created globally.
- Meteor, comet, UFO flyby and drone feed start when the object arrives after the event.
- Floating object no longer locked when the effect fails to start.
- Laser and UFO seeker craters removed.
- Searchlight loop stops when its mount dies.
- Missile, tracer and volcano range checks use the camera.

## Version: 4.0.0 - Major Release
- Complete refactor of every component onto a shared CBA framework: per-frame handlers instead of spawn/sleep loops, CBA events instead of publicVariable broadcasts, JIP-safe effect starts, and one invisible anchor object per running effect instance.
- Every effect is now available in BOTH Zeus (ZEN dialog) and the 3DEN editor (module with attributes).
- Effects are multi-instance: the same effect can run at several places at once, and the Terminate Effects module lists every running instance with per-instance stop, per-effect stop-all and a global stop.
- Added CBA settings: master enable, per-module enable (server side whitelist/blacklist), global damage kill-switch, effect view distance, particle budget, verbose debug logging and per-component tunables.
- Works with and without ACE: infantry damage routes through ACE medical when loaded, plain damage otherwise.
- New effects: Fireworks Display, Orbital Laser Strike, Napalm Strike, Carpet Bombing Strike, Lightning Storm, Acid Rain, Heat Mirage, Water Contamination, EMP Pulse, Bird Swarm, Live Briefing Map, Briefing Table diorama, plus an optional standalone red water recolor addon (watercolor).
- Fully modular: each PBO is independently deletable; the rest of the mod keeps working without it.
- Renamed the fallstar component to meteor and standardized all remaining non-English identifiers, sound class names and sound file names to English.
- Fixed: hardcoded Tanoa coordinates in the volcano lethality, damage being applied once per connected client by the AA barrage, wrong ACE medical function name in four components, several undefined variables and broken sound class references, missing JIP support, and leftover debug logging.
- Sounds moved out of the main PBO into the components that use them, so deleting a component also removes its audio.
- Rebuilt addon with HEMTT.
- Open-sourced project. You can view code, comment on how terrible or disgusting it is via issues. Bonus points if you contribute by raising pull requests [url=https://github.com/A3-Root/Root_Effects]by clicking here![/url]
- License changed to ARMA PUBLIC LICENSE SHARE ALIKE (APL-SA) - Have fun with the code. Don't forget to credit the authors (Root and Aliascartoons).
- New logo added (and now be visible in-game) with link to Github repository.
- Fireflies glow and blink at random; sparks glow in the dark.
- Aurora and Spacetime Rupture: shape, spawn/despawn speed, lifetime, density and fixed-in-place options.
- Acid Rain falls down, has an intensity setting and does no damage indoors.
- Lightning Storm: visible bolts with flash, strength setting for cloud, rain and fog.
- Orbital Laser and Singularity: damage % slider, GBU-12 blast, buildings flattened at high damage.
- Scree Avalanche damages and shoves vehicles and their crews.
- Fixed Drone Feed dialog errors, missing sound files and final-function override warnings.
- Fireflies no longer light up the ground.
- Drone Feed: gunner view follows the turret; satellite looks down, map-click retarget; Take/Release Control.
- Briefing Table: objects sit on the table top, no empty tiles, follows the marker shape.
- Singularity: collapse waits for the alarm, throws props and vehicles, lethal at the core with ACE.
- Scree Avalanche: real physics boulders that hit and damage units and vehicles.
- Acid Rain: visible downpour, optional engine rain, damages vehicles and buildings, safe zones.
- Lightning Storm: optional tornado, optionally throws objects.
- Artillery Barrage: bigger flash, fireball and smoke; sounds no longer cut off.
- Aurora/Rupture: size, length, shape switch timer, rupture movement; new Modify Sky Effect module.
- Debug Output setting: who/where/what logging for every module, chat relay for Zeus.
- Fixed missing module icon texture.
- Fixed Acid Rain crashing the game (texture used as particle model).
- Fixed smoke showing icon sprites (artillery, cryo, laser, singularity, volcano, tornado).
- Effects are drawn by camera distance, so Zeus sees them from afar.
- Scree Avalanche: dust and scree back; boulders roll and bounce down the terrain, same for every player.
- Singularity: units thrown into ragdoll, everyone in the zone killed after the collapse when damage is on.
- Orbital Laser and Singularity put out street lamps and vehicle lights in the radius.
- Drone Feed: Zeus no longer kicked out near a screen; gunner view picks a ground-facing source; satellite action labels.
- Live Briefing Map: map clicks apply instantly, double clicks no longer open the marker dialog.
- Briefing Table: table top measured by ray, solid ground colours, placement logged.
- Debug Output defaults to RPT; every function logs its call and arguments.
- Briefing Table: back to the original JSOC table logic (tilted, overlapping terrain tiles), Height Offset option, icon markers show 250 m; Zeus can spawn the table on the ground.
- Drone Feed: gunner view follows the turret camera.
- Singularity: throws first, kills mid-air a second later.
- Scree Avalanche: real physics boulders again (rock drawn on each), custom static classes roll too, the slide front damages again.
- Acid Rain: original rain particle, falling from the sky.
- Tornado: solid funnel, faster default path.
- Briefing Table: tiles with missing or unusable terrain textures use a ground colour.
- Drone Feed: gunner camera steadied (render-time turret points, smoothed aim).
- Singularity: destroys every building, wall and tree in the radius; stronger throw.
- Tornado: tapered funnel with a dark core; wind pushes away and slows everything in its wall, which keeps taking damage up to destruction.
