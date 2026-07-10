# Root's Effects — Reworked Effects for Zeus and 3DEN

Effects suite based on Aliascartoons' Effects showcase, rebuilt on CBA. Every effect is available both as a Zeus module (with a full ZEN dialog) and as a 3DEN editor module (with attributes), found under the "Root's Effects" category in the Modules list.

**Current Version**: 3.0.0

## Required Additional Addons (Dependencies):
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)
- [Zeus Enhanced (ZEN)](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631)

## Optional Addons (Supplemental):
- [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) — effect damage automatically routes through ACE medical when loaded.
- [Root's Anomalies - Zeus Module](https://steamcommunity.com/sharedfiles/filedetails/?id=2882374586)

---

Signed and built for dedicated servers. Effects render locally on each client, damage is applied once on the server, and running effects are JIP-safe: players connecting mid-mission see them immediately.

**Modular by design:** every component is its own PBO. Delete any effect PBO you do not want and the rest of the mod keeps working.

**Server control:** CBA settings provide a master switch, a per-module whitelist/blacklist, a global damage kill-switch, an effect view distance cap, a client particle budget and verbose debug logging.

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

### **Ambient Fireflies, Sparks, Aurora, Rupture, Bird Swarm** (ambientsfx)
- Fireflies glittering at night with optional frog croaks.
- Electrical spark showers with crackle sounds.
- Aurora borealis and spacetime rupture glowing in the night sky.
- A flock of eagles circling an area.

### **Anti Air Barrage, Artillery Barrage, Missile Launcher, Searchlight, Tracer Fire** (battlescripts)
- Flak barrage with optional aircraft and infantry damage.
- Artillery with lethal (real shells), non-lethal (visuals) and sound-only modes.
- Ambient rocket launches, a sweeping searchlight with optional air raid alarm, and ambient tracer volleys.

### **Meteors / Comets** (meteor)
- Meteors crashing near random players with optional lethal impacts.
- Comets streaking across the sky.

### **UFO Encounter, Seeker, Crop Circle** (ufo)
- Random UFO sightings: fast crossings and hovering light charges.
- A seeker orb landing and sweeping the area near players.
- Crop circles burned into the ground in circle, spiral or flower patterns.

### **Volcanic Eruption** (volcano)
- Ash column, crater glow, recurring eruptions, crater lava, lava flows, cloud lightning and position-based lethality with configurable protective gear.

### **Floating Objects** (floatingobjects)
- Levitates an object and animates it with slide, bounce, rotation, rollover and orbit movements.

### **Freeze Players** (freeze)
- Freezes or unfreezes players, either by stopping their simulation or with a looping animation.

### **Fireworks Display** (fireworks)
- Colorful rockets and bursts at a configurable rate, duration, radius and height. Fully client side.

### **Orbital Laser, Napalm Strike, Carpet Bombing** (strikes)
- A charging beam from the sky with a devastating detonation.
- An attack run igniting a burning corridor with periodic burn damage.
- Bombers walking a stick of real bombs along a line — proven design for large dedicated servers.

### **Lightning Storm, Acid Rain, Heat Mirage, Water Contamination** (weather)
- Real lightning bolts striking a configurable area.
- Acid rain that burns units caught in the open.
- A shimmering heat haze zone.
- A contaminated-water zone that tints the view, far stronger while diving.

### **EMP Pulse** (emp)
- Cuts vehicle engines, optionally drains fuel and distorts the vision of players inside the radius.

### **Live Briefing Map, Briefing Table** (briefing)
- A map board with a live topographic feed, optionally following a marker.
- A miniature diorama of a marker area built on any table, including terrain relief.

---

#  LICENSE

![License](https://i.imgur.com/jUUdDUu.png)

Project is now open-sourced under the [Arma Public License Share Alike (APL-SA) License!](https://www.bohemia.net/community/licenses/arma-public-license-share-alike)
