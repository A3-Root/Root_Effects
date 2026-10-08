# Root's Effects — Reworked Effects for Zeus and 3DEN

![version](https://img.shields.io/badge/version-3.0.0.6-blue)
[![build](https://github.com/A3-Root/Root_Effects/actions/workflows/auto-release.yml/badge.svg?branch=master)](https://github.com/A3-Root/Root_Effects/actions/workflows/auto-release.yml)

Effects suite based on Aliascartoons' Effects showcase, rebuilt on CBA. Every effect is available both as a Zeus module (with a full ZEN dialog) and as a 3DEN editor module (with attributes), found under the "Root's Effects" category in the Modules list.

**Current Version**: 3.0.0

## Required Additional Addons (Dependencies):
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)
- [Zeus Enhanced (ZEN)](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631)

## Optional Addons (Supplemental):
- [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) — effect damage automatically routes through ACE medical when loaded.
- [Root's Anomalies - Zeus Module](https://steamcommunity.com/sharedfiles/filedetails/?id=2882374586)

---

Works in single player, hosted multiplayer and on dedicated servers, with or without headless clients. Effects render locally on each client, damage is applied once on the server (routed to whichever machine owns the target), and running effects are JIP-safe: players connecting mid-mission see them immediately.

**Modular by design:** every component is its own PBO. Delete any effect PBO you do not want and the rest of the mod keeps working.

**Server control:** CBA settings provide a master switch, a per-module whitelist/blacklist, a global damage kill-switch, an effect view distance cap, a client particle budget and debug output.

**Debugging:** set *Debug Output* (CBA settings, Root's Effects > General) to *RPT log* or *RPT log + chat for Zeus/admins*. Every Zeus request (who, where, what), 3DEN module activation, effect start/stop, client side render start, damage dealt and rejected request is logged with the component, the machine (host, server, headless client or client) and the mission time. In chat mode, server and headless client lines are relayed to every Zeus.

![Example GIF](https://i.imgur.com/EWy3dQc.gif)

**Feedback/Suggestions/Bugfixes/Review welcome.**

Useful for **Stalker**, **SCP**, **Halloween**, **F.E.A.R**, **Horror**, **Sci-Fi**, **World War 2 (WW2)**, or other themed missions.

---

# Effects

All effects appear in the "Root's Effects" category of the Zeus Modules tab and in 3DEN under Systems > Modules. Every parameter has a tooltip. Running effects can be stopped one by one, per type, or all at once through the **Terminate Effects** module, even when the same effect runs at several places simultaneously.

### **Terminate Effects** (main)
- Lists every running effect instance with its grid and runtime.
- Stop a single instance, all instances of one effect, or everything.

### **AAN News Article** (news)
- Fully customizable AAN news article shown to the selected sides, groups or players.
- Optional fade-in title card and a diary entry that reopens the article any time.

### **Ambient Fireflies, Sparks, Bird Swarm** (ambientsfx)
- Fireflies that glow in the dark and blink on and off at random, with optional frog croaks.
- Electrical spark showers that glow and flash at night, with crackle sounds.
- A flock of eagles circling an area.

### **Aurora Borealis, Spacetime Rupture, Modify Sky Effect** (ambientsfx)
- Glowing bands in the night sky: band, arc, wave, ring, spiral or random shape.
- Fade in / fade out speed, lifetime, density, size scale and length scale.
- Optional shape switch timer: the band takes on a new form every X seconds.
- The rupture can move: drift on one heading or wander around where it started.
- Modify Sky Effect (Zeus and 3DEN, trigger activated) changes a running aurora or rupture live: Keep As Is (holds every light exactly where it is), allow or stop new lights, allow or stop lights fading out, size, length, shape, shape switching and movement.

### **Anti Air Barrage, Artillery Barrage, Missile Launcher, Searchlight, Tracer Fire** (battlescripts)
- Flak barrage with optional aircraft and infantry damage.
- Artillery with lethal (real shells), non-lethal (visuals) and sound-only modes. Visual impacts have a flak-style flash with lens flare, a fireball, sparks, flying earth, a dust ring, a dark smoke column and smouldering craters. Every impact keeps its own sound, so shells no longer cut each other off.
- Ambient rocket launches, a sweeping searchlight with optional air raid alarm, and ambient tracer volleys.

### **Drone Feed** (dronefeed)
- Streams a drone camera or a satellite view onto any screen object.
- Drone: gunner, driver or alternating view. The gunner view follows the turret wherever the operator points it.
- Satellite: looks straight down from orbit. The controller retargets it by clicking the map.
- Anyone at the screen can Take Control / Release Control. The controller gets zoom, vision mode, view cycling (drone) or map retargeting (satellite).

### **Meteors / Comets** (meteor)
- Meteors crashing near random players with optional lethal impacts.
- Comets streaking across the sky.

### **UFO Encounter, Seeker, Crop Circle** (ufo)
- Random UFO sightings: fast crossings and hovering light charges.
- A seeker orb landing and sweeping the area near players.
- Crop circles burned into the ground in circle, spiral or flower patterns.

### **Volcanic Eruption, Scree Avalanche** (volcano)
- Ash column, crater glow, recurring eruptions, crater lava, lava flows, cloud lightning and position-based lethality with configurable protective gear.
- Scree avalanche: a dust and scree cascade plus real, physically simulated boulders that bounce down the slope and crush and shove the people and vehicles they hit.

### **Floating Objects** (floatingobjects)
- Levitates an object and animates it with slide, bounce, rotation, rollover and orbit movements.

### **Freeze Players** (freeze)
- Freezes or unfreezes players, either by stopping their simulation or with a looping animation.

### **Fireworks Display** (fireworks)
- Colorful rockets and bursts at a configurable rate, duration, radius and height. Fully client side.

### **Orbital Laser, Singularity, Napalm Strike, Carpet Bombing** (strikes)
- Orbital Laser: a charging beam from the sky with a devastating detonation.
- Singularity: a pulsing anomaly that charges up behind a warning alarm (the collapse always waits for the alarm to finish), then collapses and throws people, vehicles, crates and props into the air.
- Both have a 0-100% damage slider. Any damage sets off a real GBU-12 and adds scaled damage on top. 100% destroys everything at the core and flattens buildings, walls and trees in roughly the inner half of the radius.
- Napalm: an attack run igniting a burning corridor with periodic burn damage.
- Carpet Bombing: bombers walking a stick of real bombs along a line.

### **Lightning Storm, Acid Rain, Heat Mirage, Water Contamination** (weather)
- Lightning Storm: visible bolts with a blinding flash and distance-delayed thunder. Strength sets cloud, rain, fog and strike rate. The previous weather comes back when the storm ends.
- Optional tornado: a towering, spinning funnel with a dust and debris skirt that wanders through the storm. Optionally it lifts, throws and damages what it passes.
- Acid Rain: a heavy green downpour (optionally real engine rain as well) that slowly burns people in the open, corrodes vehicles and weathers buildings, walls and props up to a damage cap.
- Acid Rain safe zones: protective gear, protected vehicle and building classes, area markers or triggers, and any object flagged with root_effects_acidSafe. Anyone under a roof is safe too.
- Heat Mirage: a shimmering heat haze zone.
- Water Contamination: a contaminated-water zone that tints the view, far stronger while diving.

### **EMP Pulse** (emp)
- Cuts vehicle engines, optionally drains fuel and distorts the vision of players inside the radius.

### **Live Briefing Map, Briefing Table** (briefing)
- A map board with a live topographic feed, optionally following a marker.
- A miniature diorama of a marker area built on top of any table: terrain relief tiles following the marker shape, with the area's buildings and objects standing on them.

---

#  LICENSE

![License](https://i.imgur.com/jUUdDUu.png)

Project is now open-sourced under the [Arma Public License Share Alike (APL-SA) License!](https://www.bohemia.net/community/licenses/arma-public-license-share-alike)
