# Briefing Table

Builds a miniature diorama of a marker area on top of a table object.

- Place an area marker (rectangle or ellipse) over the area and point the module at it.
- The miniature sits on the real top surface of the table model, centred on it.
- With terrain relief on, the ground is laid as small tiles textured from the terrain; tiles outside an ellipse or rotated rectangle are skipped. Where the terrain has no usable texture, the tile is coloured by ground type (grass, sand, rock, road, water).
- Buildings and objects of the area are cloned as small simple objects standing on the relief.
- *Resolution* sets tiles per side (8-40); *Scale* sets how much of the table is used; the object count is capped by the CBA setting.
- Everything is local to each client and removed with the instance.
