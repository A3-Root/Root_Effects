# Acid Rain

## Look
- A heavy, green-tinted downpour falling from 30-40 m above each player inside the zone (the original acid rain particle, now falling), with a low acidic mist, colour grading and film grain. *Intensity* scales all of it.
- **Weather Rain**: the server also brings in heavy cloud and real engine rain for the storm (restored afterwards); players inside the zone see that rain tinted green.
- No rain falls on players who are indoors.

## Damage (server, every tick)
| Setting | Effect |
|---|---|
| Damage per tick | Burn damage to people in the open. |
| Vehicle Corrosion | Hitpoint and hull damage to vehicles in the zone; crews inside are protected. |
| Building Weathering | Damage to buildings, walls, fences and props, worked through a slice per tick. |
| Building Damage Cap | Highest damage the rain can do to a structure; 100% lets it collapse. |

## Safe zones
Nothing is damaged when any of these apply:
- **Protective Gear**: the unit wears any listed item (helmet, goggles, uniform, vest, backpack, NVG slot).
- **Protected Vehicles**: vehicle class or parent class (e.g. `Tank`).
- **Protected Buildings**: building class or parent class; units inside are safe too.
- **Safe Zones**: area marker names or trigger variable names.
- Any object with `this setVariable ["root_effects_acidSafe", true, true];`.
- A roof overhead (people and parked vehicles).
