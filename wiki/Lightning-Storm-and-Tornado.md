# Lightning Storm and Tornado

## Storm
- Real lightning strikes at random points of the area. Each strike shows a bolt, a flickering flash that lights up the surroundings, and thunder delayed by distance.
- **Strength** scales cloud cover, rain, fog, ambient lightning, strike rate and flash brightness. The previous weather is eased back when the storm ends.
- **Damage**: strikes hurt units, vehicles, boats and statics within 15 m.

## Tornado
- **Tornado**: a solid, towering funnel of dark cloud (26 overlapping spinning layers, narrow at the ground and opening up to 400 m), a wall cloud on top, a dust skirt and flying debris at its foot, a howling wind and camera shake when close.
- **Width** (50-300 m) and **Speed** (m/s, default 15) set its size and how fast it travels. Its position is logged every 10 s.
- Its path wanders through the storm area. The path is computed from mission time on every machine, so all players see it in the same place without syncing a moving object.
- **Throws Objects**: people, vehicles, boats, statics and props near its foot are spun, drawn in, lifted and damaged. Off means purely visual.
