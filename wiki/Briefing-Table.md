# Briefing Table

Builds a miniature diorama of a marker area on top of a table object (based on the 77th JSOC briefing table script).

- **Zeus**: place the module on a table, or on the ground and pick a table to spawn there (Briefing Room Desk, Large Table, Large Wooden Table, Camping Table, Plastic Table). A spawned table is removed with the miniature.
- **3DEN**: sync the module to a table, or place it within 10 m of one.
- **Marker**: use an area marker (rectangle or ellipse) covering the area to model. An icon marker, or an area under 20 m, shows 250 m around it.
- With terrain relief on, the ground is laid as textured cubes, each tilted to the terrain slope under it and enlarged by the tilt so neighbouring tiles always overlap.
- **Height Offset** (default 0.4 m) lifts the whole miniature: raise it if pieces sink into the table top, lower it if they float.
- Buildings and objects of the area are cloned as small simple objects.
- *Resolution* sets tiles per side (8-40); *Scale* sets how much of the table is used; the object count is capped by the CBA setting.
- Everything is local to each client and removed with the instance. The RPT log lists the table, marker area, scale, lift and piece counts.
