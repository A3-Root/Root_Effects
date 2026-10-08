# Scree Avalanche

- Dust, scree and small rock particles cascade down the slope (downhill automatically, or a set heading).
- **Boulders** (0-80): real physics boulders. Each is an engine physics prop (invisible but solid) with a rock drawn on it by every client, so it bounces, rolls, knocks into vehicles and people and comes to rest on its own. Settled boulders are cleared after about 20 s.
- **Objects**: comma separated class names rolled down with it. Classes with their own physics (props, vehicles) are spawned and shoved; static classes (for example `Land_TimberLog_04_F`) ride an invisible physics prop the same way a boulder does.
- **Lethal**: everything in the moving front of the slide (a band about 35 m long and 44 m wide) is crushed and shoved downhill, and every fast boulder or object hurts what it hits. Vehicles take hitpoint and hull damage and their crews are hurt. Infantry damage is raised under ACE.
