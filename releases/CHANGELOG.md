# Changelog for Root's Effects

## Version: 4.0.0.6
### Changed
- EMP dome reaches the ground again (bottom ring of patches was not created).
- EMP Modify EMP Field changes dome colour and opacity again.
- EMP lightning: shorter bolts, fewer arcs around players, wave front bolts in step with the wave.
- EMP breaking lamps: sparks plus a small lightning burst; detonation sparks back alongside the burst.
- EMP Implosion Blast explodes (shell no longer duds).

## Version: 4.0.0.5
### Changed
- EMP dome: glass material, built from curved 15 degree patches so it shows from inside.
- EMP lightning: EMP Systems style bolt bursts at detonation, on the wave front, on the dome, inside the dome and at the implosion.
- EMP heat haze: stronger on the dome and inside, on the wave front and at detonation.
- EMP light flicker no longer restarts every tick while the field shuts down.

## Version: 4.0.0.4
### Removed
- EMP: Fog Inside and Fog Opacity options, CBA setting Dome Fog Quality.
- EMP: Dome Opacity Inside option.
- EMP: hint on entering a live field.

### Changed
- EMP defaults: 500 m radius and dome height, 10 s countdown, linger until shut down, 50 m/s shockwave, broken lights, warning 500 m helicopter / 1000 m plane, no charge glow, no screen interference, 25 % dome, implode with small blast, all flicker on, area + label marker, no countdown timer, 12 m shutdown distance.
- EMP Zeus modules attach to the object they are placed on.
- EMP dome: own model, same look from inside and outside, self-lit at night, no panels.
- EMP lightning bolts sized to the scene, self-lit, seen from all sides.
- EMP dome area: arcs, sparks, crackle and heat haze around players inside.
- EMP implode: wall runs back in at the shockwave speed, marker shrinks, units recover as it passes, blast when it arrives.

## Version: 4.0.0.3
### Added
- EMP: Flicker Lit Min/Max and Flicker Dark Min/Max options.
- EMP: Shutdown Distance option.
- EMP: Shutdown Effect option (Fade, Implode) and Implosion Blast (Off, Small, Large).
- EMP: Dome Opacity Inside option.
- EMP CBA setting: Allow Implosion Blast.

### Changed
- EMP fog visible, denser at full opacity.
- EMP light flicker: lit 5 - 20 s, stutter, dark 2 - 10 s by default.
- EMP ACE shutdown action at the object root, reach from the object bounds.
- EMP dome from inside: no overlapping panel squares, higher opacity, ground line glow in the dark.

## Version: 4.0.0.2
### Added
- EMP: Flicker Weapon Lights, Flicker Vehicle Lights and Flicker Lamps options.
- EMP: Dome Lightning and Dome Heat Haze options.
- EMP: Fog Inside and Fog Opacity options.
- EMP: shutdown interaction on an invisible wall for fields on the ground.
- EMP CBA settings: Allow Light Flicker, Dome Fog Quality.

### Changed
- EMP dome visible from inside.
- EMP shockwave front: larger lightning bolts, sparks and light flicker.
- EMP sparks use the Ambient Sparks look and sound.
- EMP suppress mode takes electronic devices and gives them back on leaving.
- Shared post process helper picks a free priority.

### Fixed
- EMP shielded items (e.g. weapon lights) were still turned off.
- EMP extra electronics kept working in suppress mode.
- EMP ACE interaction missing on objects without ACE main actions; shutdown range scales with object size.
- Drone feed RPT error spam in the turret aim lookup.
- Sounds from client side effects played once per player (EMP, fireworks, cryo blast, meteor, laser, singularity, UFO, lightning).
- Briefing map take / release control actions.
- Comet flight direction.
- Napalm damage area rotated.
- Meteor knock back on remote units.
- Singularity fling hook created globally.
- Meteor, comet, UFO flyby and drone feed setup when the object arrives after the event.
- Floating object locked when the effect fails to start.
- Laser and UFO seeker craters never removed.
- Drone feed monitor removing feeds while iterating.
- Searchlight loop kept running after its mount died.
- Missile, tracer and volcano range checks used the player instead of the camera.

## Version: 4.0.0.1
### Added
- Build-up time for Aurora, Spacetime Rupture, Lightning Storm and Acid Rain: instant, X seconds or default.
- Snap To Full option in Modify Sky Effect.
- EMP Field: countdown, shockwave, dome, Zeus-editable marker, delayed knockout, grace time, recovery on leaving, shutdown on the object (hold action / ACE).
- EMP Field: vehicle, aircraft, UAV, lamp and gear modes; cTab, ACE device, UAV terminal and ACRE radio suppression.
- EMP public API: create, disable, modify, isInside.
- Modify EMP Field module (Zeus and 3DEN): change settings live or shut down.
- EMP approach warning: HUD blinks out near the field, ranges for ground, helicopter and plane.
- EMP Charge Glow option.
- EMP shockwave carries lightning bolts and crackle; Broken lamps, destroyed vehicles and fried gear burst into sparks.
- EMP CBA settings: Allow Destroy And Fry, Jam ACRE Radios, Dome Quality, Show Countdown Timer.

### Changed
- EMP Pulse is now EMP Field; the 3DEN module is trigger activated and syncs to an object.
- Late joiners see aurora and rupture bands at full strength.
- EMP knocked out vehicles get engine hitpoints wrecked until recovery; engines cannot be restarted inside.
- EMP dome: tinted glass with surface haze, visible from inside; default grey 0.5 at 3 %.

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
