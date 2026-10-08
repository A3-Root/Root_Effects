# Lightning Storm and Tornado

## Storm
- Real lightning strikes at random points of the area. Each strike shows a bolt, a flickering flash that lights up the surroundings, and thunder delayed by distance.
- **Strength** scales cloud cover, rain, fog, ambient lightning, strike rate and flash brightness. The previous weather is eased back when the storm ends.
- **Damage**: strikes hurt units, vehicles, boats and statics within 15 m.

## Tornado
- **Tornado**: a towering funnel (40 spinning layers of churning smoke: a tight dusty rope at the ground flaring into a wide grey cone up to 420 m, with a dark core), a wall cloud on top, a dust skirt and flying debris at its foot, a howling wind and camera shake when close.
- **Width** (50-300 m) and **Speed** (m/s, default 15) set its size and how fast it travels. Its position is logged every 10 s.
- Its path wanders through the storm area. The path is computed from mission time on every machine, so all players see it in the same place without syncing a moving object.
- **Wind (always)**: anything inside the tornado's wall (half its width from the centre) is blown away from the funnel and slowed down, and people, vehicles, buildings, walls and trees there keep taking damage until destroyed. Respects the damage settings.
- **Throws Objects**: additionally, whatever gets near the core is sucked in, spun and lifted.
