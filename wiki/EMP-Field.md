# EMP Field

An electromagnetic pulse field on an object (e.g. `RuggedTerminal_01_communications_hub_F`) or a position.

Sequence:
1. Countdown: beeps from the object (faster towards zero), timer over the object, optional hint, optional blue charge glow over the last 3 s. Shutting the object down aborts it (if allowed).
2. Detonation: flash, lightning arcs, sparks, thunder and blast.
3. Shockwave: glowing ring running out at the shockwave speed, lightning bolts, sparks, light flicker and crackle riding its front. The map marker and the dome grow with it.
4. Knockout: each unit, vehicle and lamp fails when the wave reaches it, plus the effect delay.
5. Field: lasts the linger time (-1: until shut down). Players nearing the field see their HUD blink out (warning range by ground, helicopter or plane). Units and vehicles entering later get the grace time to turn away; still inside after it, engines, lights and gear die. Knocked out vehicles get their engine wrecked (kept wrecked inside), so they cannot be restarted; Disable mode repairs it on recovery. With Recover On Leaving, gear and vehicles work again outside the field.
6. End: linger runs out, a player shuts it down on the object (a field on the ground: on an invisible wall at its center), Zeus terminates it, or the object is destroyed. The dome fades, the marker goes, everything suppressed or disabled recovers. Destroyed and fried items stay broken.

## Zeus
Place **EMP Field** on an object to put the field there, or on the ground. Fields appear in **Terminate Effects**.

**Modify EMP Field**: place on the field's object (or near the field). The dialog shows the current settings; change any of them live, or tick **Shut Down**.

## 3DEN
**EMP Field** module. Sync it to an object to put the field there. Sync a trigger to start it when the trigger fires; without one it starts at mission start.

**Modify EMP Field** module, trigger activated: changes the field on the synced object, otherwise the closest within the search range. Shut Down, Radius (-1 unchanged), Linger (-2 unchanged), Dome (-1 unchanged, 0 off, 1 on), Other Settings as `[["key", value], ...]`.

## Options
| Option | Meaning |
|---|---|
| Radius | Ground radius in meters. |
| Dome Height | Height of the field. -1: no height limit (dome drawn as a hemisphere). The field is a spherical cap with that radius and height. |
| Countdown | Seconds to detonation. 0: immediate. |
| Linger | Seconds the field stays after the shockwave. -1: until shut down. |
| Shockwave Speed | m/s. 0: instant. |
| Effect Delay | Seconds between the wave passing and the knockout. |
| Vehicles / Aircraft | Off, Disable (engine wrecked until recovery, lights off, thermal and night optics off, sensors and info panels off for the crew), Destroy (engine, avionics, electrics and light hitpoints wrecked). |
| UAVs | Off, Disconnect (no terminal control of UAVs inside, nor from inside), Crash (engine off as well). |
| Lights | Off, Out (relit when the field ends), Broken (flicker, burst into sparks, some blow out, stay out). Sparks look and sound like Ambient Sparks. |
| Personal Electronics | Off, Suppress (items kept, dead inside; devices taken and given back), Fry (items removed). |
| Affect AI Gear | AI lose electronic goggles, weapon lights and IR lasers. |
| Jam Radios | ACRE radios inside neither send nor receive. |
| Block Voice Channels | Players hit lose side, command, group and vehicle voice. |
| Fuel Drain | Fraction of fuel drained from vehicles knocked out. |
| Recover On Leaving | Off: affected units and vehicles stay dead until the field ends. |
| Grace Time | Seconds before units entering the live field are hit. |
| Warning Range Ground / Helicopter / Plane | Meters outside the field where the HUD of approaching players blinks out (default 50 / 200 / 500, 0 off). |
| Detonation Effects, Charge Glow, Camera Shake, Screen Interference | Visual and HUD effects. Thermal sights drown in noise. |
| Force Field Dome, Colour, Opacity, Shimmer | Tinted glass dome (default grey 0.5, 3 %), visible from inside and outside. Shimmer: the dome pulses (high quality). No collision: units, vehicles and bullets pass through. |
| Dome Lightning | Lightning arcs flash at random on the dome. |
| Dome Heat Haze | Heat haze on the dome surface only, densest at the ground line. |
| Fog Inside, Fog Opacity | Fog fills the dome. Outside the dome the weather is unchanged. |
| Flicker Weapon Lights / Vehicle Lights / Lamps | Lights switched on inside (and lamps) flicker at random: short bursts between pauses, never steady. Off: they stay off. Switching the light off ends the flicker. Leaving the field puts weapon and vehicle lights back on. |
| Map Marker | Off, Area, Area + Label. Zeus can edit it (ZEN area markers). |
| Marker Sets Radius | Zeus resizing the marker changes the radius. |
| Countdown Beep, Timer, Hint | Countdown display. |
| Shutdown Interaction | Off, Action (hold action), ACE (ACE interaction, falls back to the hold action without ACE), Both. Usable within 3 m of the object. A field on the ground gets an invisible wall (`Land_InvisibleBarrier_F`) at its center to carry it, removed with the field. |
| Shutdown Time | Seconds the shutdown takes. |
| Required Item | Classname needed to shut down (e.g. `ToolKit`). Empty: none. |
| Can Abort Countdown | Shutdown works before detonation. |
| Ends With Object | Field ends when its object is destroyed. |
| Extra Electronics, Shielded Items, Shielded Vehicles | Comma separated classnames. Shielded items (e.g. `acc_flashlight`) keep working. Shielded vehicles include child classes. |

Suppressed gear while hit: electronic goggles off, electronic weapon lights and lasers off, electronic binoculars put away, info panels off, UAV terminal disconnected and closed, cTab, ACE microDAGR, DAGR, Kestrel and HuntIR closed. Electronic devices (GPS slot, terminals, cTab, ACE devices, extra items; not goggles, binoculars, weapon attachments or radios) are taken from the inventory and given back on release: into their slot or the inventory, on the ground when full, onto the body when dead.

Electronic items: night vision, radio and GPS / terminal slot items, weapon lights and lasers, binoculars with night, thermal, laser or rangefinder function, cTab devices (`ItemcTab`, `ItemAndroid`, `ItemMicroDAGR`, `ItemGalaxy`, ...), ACE devices, ACRE radios, extra electronics. Shielded items override all.

## CBA settings
| Setting | Scope |
|---|---|
| Enable EMP Module | server |
| Allow Vehicle Knockout | server; off: vehicles and aircraft not affected |
| Allow Destroy And Fry | server; off: those modes act as Disable / Suppress |
| Jam ACRE Radios | server |
| Allow Light Flicker | server; off: flicker options act as off |
| Dome Quality | client: off, low (fewer panels, haze and arcs, no shimmer), high |
| Dome Fog Quality | client: off, low, high |
| Show Countdown Timer | client |

## API
```sqf
// Create (any machine; runs on the server). Missing keys use root_effects_emp_fnc_empDefaults.
[terminal_1, createHashMapFromArray [["radius", 400], ["countdown", 30], ["linger", -1]]] call root_effects_emp_fnc_create;
// Shut down, by object or anchor.
[terminal_1] call root_effects_emp_fnc_disable;
// Change a running field.
[terminal_1, createHashMapFromArray [["radius", 600], ["dome", false]]] call root_effects_emp_fnc_modify;
// Inside an active field the wave has reached (any machine).
[player] call root_effects_emp_fnc_isInside;
```
Settings keys: `radius`, `altitude`, `countdown`, `linger`, `shockSpeed`, `effectDelay`, `vehicles`, `aircraft`, `uavs`, `lamps`, `gear`, `ai`, `radios`, `channels`, `fuelDrain`, `restore`, `grace`, `warnGround`, `warnHeli`, `warnPlane`, `visuals`, `chargeGlow`, `shake`, `hud`, `dome`, `domeColor`, `domeAlpha`, `domeShimmer`, `domeLightning`, `domeMirage`, `fog`, `fogAlpha`, `flickerGear`, `flickerVehicles`, `flickerLamps`, `marker`, `markerSync`, `beep`, `timer3D`, `timerHint`, `interaction`, `holdTime`, `requiredItem`, `abortCountdown`, `endOnDestroyed`, `itemsExtra`, `itemsImmune`, `vehiclesImmune`.

## Locality
- SP: everything runs locally.
- MP host / dedicated: the server owns the field, marker, linger, shutdown and the invisible wall. Every machine knocks out and recovers the units and vehicles local to it and flickers their lights. Clients draw countdown, detonation, dome, fog, lamps and lamp flicker, and suppress their own player's gear. All sounds play locally once per client.
- Headless client: knocks out its local AI and vehicles and flickers their lights. No visuals.
- JIP: late joiners get the field, dome, fog, dark lamps and the shutdown interaction at once.
